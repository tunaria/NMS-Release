/**
 * @file dailifyer_window.cpp
 * @brief DailifyerWnd implementation: lists the challenges the server sends and forwards the
 *        Accept Challenge / Plunder buttons to the NPC that opened the window.
 */

#include "dailifyer_window.h"

#include <cstddef>
#include <cstdio>
#include <cstring>

extern bool isDailifyerWindowEnabled;
extern VOID SendEQMessage(DWORD PacketType, PVOID pData, DWORD Length);
extern void AddXMLFile(const char* filename);

namespace
{
    // Opcodes and packets mirror Release-NMS-Server (utils/patches/patch_RoF2.conf and
    // common/eq_packet_structs.h). There is no shared header: change both sides together.
    constexpr uint16_t OP_DAILIFYER_WINDOW = 0x140A;
    constexpr uint16_t OP_DAILIFYER_REQUEST = 0x140B;

    // The server never sends more (DAILIFYER_MAX_CHALLENGES in zone/nms_dailifyer.cpp).
    constexpr uint32_t MAX_CHALLENGES = 32;

    enum class DailifyerStatus : uint8_t
    {
        Available = 0,
        Completed = 1,
        LockedOut = 2,
        InProgress = 3
    };

    enum class DailifyerAction : uint8_t
    {
        Challenge = 1,
        Plunder = 2
    };

#pragma pack(push, 1)
    struct DailifyerChallenge_Struct
    {
        uint32_t challenge_id;
        uint8_t status;
        uint8_t completed;
        uint32_t lockout_seconds;
        char name[64];
        char objective[256];
    };

    struct DailifyerWindow_Struct
    {
        uint32_t npc_id;
        char npc_name[64];
        uint32_t challenge_count;
        DailifyerChallenge_Struct challenges[1];
    };

    struct DailifyerRequest_Struct
    {
        uint32_t npc_id;
        uint32_t challenge_id;
        uint8_t action;
    };
#pragma pack(pop)

    constexpr size_t WINDOW_HEADER_SIZE = offsetof(DailifyerWindow_Struct, challenges);

    constexpr COLORREF COLOR_WHITE = 0xFFFFFFFF;
    constexpr COLORREF COLOR_AVAILABLE = 0xFF80FF80;
    constexpr COLORREF COLOR_PLUNDER = 0xFFFFD700;
    constexpr COLORREF COLOR_IN_PROGRESS = 0xFF80E0FF;
    constexpr COLORREF COLOR_LOCKED = 0xFFA0A0A0;

    // List columns: 0 is a hidden data column, as in NMS_WaypointsWnd.xml.
    constexpr int COLUMN_NAME = 1;
    constexpr int COLUMN_COMPLETED = 2;
    constexpr int COLUMN_STATUS = 3;

    // Packet strings are fixed-size and may fill the whole buffer without a terminator.
    std::string NMS_ReadFixedString(const char* text, size_t size)
    {
        return std::string(text, strnlen(text, size));
    }

    std::string NMS_FormatLockout(uint32_t seconds)
    {
        const uint32_t hours = seconds / 3600;
        const uint32_t minutes = (seconds % 3600) / 60;

        char text[32];
        if (hours > 0)
            sprintf_s(text, "%uh %02um", hours, minutes);
        else if (minutes > 0)
            sprintf_s(text, "%um", minutes);
        else
            sprintf_s(text, "<1m");

        return text;
    }

    std::string NMS_DailifyerStatusText(uint8_t status, uint32_t lockout_seconds)
    {
        switch ((DailifyerStatus)status)
        {
        case DailifyerStatus::Available:
            return "Available";
        case DailifyerStatus::Completed:
            return "Ready to plunder";
        case DailifyerStatus::InProgress:
            return "In progress";
        case DailifyerStatus::LockedOut:
            return "Locked out (" + NMS_FormatLockout(lockout_seconds) + ")";
        }

        return "Unavailable";
    }

    COLORREF NMS_DailifyerStatusColor(uint8_t status)
    {
        switch ((DailifyerStatus)status)
        {
        case DailifyerStatus::Available:
            return COLOR_AVAILABLE;
        case DailifyerStatus::Completed:
            return COLOR_PLUNDER;
        case DailifyerStatus::InProgress:
            return COLOR_IN_PROGRESS;
        default:
            return COLOR_LOCKED;
        }
    }
}

DailifyerWnd* DailifyerWnd::s_instance = nullptr;

DailifyerWnd* DailifyerWnd::GetInstance()
{
    return s_instance;
}

DailifyerWnd::DailifyerWnd()
    : CCustomWnd("DailifyerWnd"), m_npcId(0)
{
    m_pNPCLabel = (CXWnd*)GetChildItem("DLF_NPCLabel");
    m_pChallengeList = (CListWnd*)GetChildItem("DLF_ChallengeList");
    m_pObjectiveLabel = (CXWnd*)GetChildItem("DLF_ObjectiveLabel");
    m_pChallengeButton = (CButtonWnd*)GetChildItem("DLF_ChallengeButton");
    m_pPlunderButton = (CButtonWnd*)GetChildItem("DLF_PlunderButton");

    if (!m_pChallengeList)
        WriteChatf("[Dailifyer] Failed to find DLF_ChallengeList!");
    if (!m_pChallengeButton || !m_pPlunderButton)
        WriteChatf("[Dailifyer] Failed to find the window buttons!");

    // Hook the WndNotification function into the vtable
    SetWndNotification(DailifyerWnd);
}

DailifyerWnd::~DailifyerWnd()
{
}

void DailifyerWnd::Initialize()
{
    if (!isDailifyerWindowEnabled)
        return;

    AddXMLFile("NMS_DailifyerWnd.xml");
}

void DailifyerWnd::Shutdown()
{
    if (s_instance)
    {
        ((CXWnd*)s_instance)->Show(false, false);
        delete s_instance;
        s_instance = nullptr;
    }
}

void DailifyerWnd::OnIncomingPacket(uint16_t opcode, void* buf, size_t size)
{
    if (opcode != OP_DAILIFYER_WINDOW || !isDailifyerWindowEnabled)
        return;

    if (!pSidlMgr->FindScreenPieceTemplate("DailifyerWnd"))
    {
        WriteChatf("[Dailifyer] Template 'DailifyerWnd' not found! UI reload may be needed.");
        return;
    }

    if (!s_instance)
        s_instance = new DailifyerWnd();

    if (s_instance->HandleWindowPacket(buf, size))
        ((CXWnd*)s_instance)->Show(true, true);
}

void DailifyerWnd::OnSetGameState(int state)
{
    if (state != 5 && s_instance)
        ((CXWnd*)s_instance)->Show(false, false);
}

bool DailifyerWnd::HandleWindowPacket(void* buf, size_t size)
{
    if (!buf || size < WINDOW_HEADER_SIZE)
    {
        WriteChatf("[Dailifyer] Packet too small for the window header!");
        return false;
    }

    const DailifyerWindow_Struct* w = (const DailifyerWindow_Struct*)buf;
    const uint32_t count = w->challenge_count;
    if (count > MAX_CHALLENGES || size < WINDOW_HEADER_SIZE + count * sizeof(DailifyerChallenge_Struct))
    {
        WriteChatf("[Dailifyer] Packet too small for %u challenges (got %u bytes).", count, (unsigned)size);
        return false;
    }

    m_npcId = w->npc_id;
    m_challenges.clear();

    for (uint32_t i = 0; i < count; i++)
    {
        const DailifyerChallenge_Struct& e = w->challenges[i];

        Challenge c;
        c.id = e.challenge_id;
        c.status = e.status;
        c.completed = e.completed != 0;
        c.lockout_seconds = e.lockout_seconds;
        c.name = NMS_ReadFixedString(e.name, sizeof(e.name));
        c.objective = NMS_ReadFixedString(e.objective, sizeof(e.objective));
        m_challenges.push_back(c);
    }

    if (m_pNPCLabel)
    {
        CXStr text(NMS_ReadFixedString(w->npc_name, sizeof(w->npc_name)).c_str());
        m_pNPCLabel->SetWindowTextA(text);
    }

    PopulateList();
    return true;
}

void DailifyerWnd::PopulateList()
{
    if (!m_pChallengeList)
        return;

    m_pChallengeList->DeleteAll();

    for (size_t i = 0; i < m_challenges.size(); i++)
    {
        const Challenge& c = m_challenges[i];
        const int index = m_pChallengeList->AddString(c.name.c_str(), COLOR_WHITE, (uint32_t)i, 0);

        CXStr name(c.name.c_str());
        m_pChallengeList->SetItemText(index, COLUMN_NAME, &name);

        CXStr completed(c.completed ? "Yes" : "No");
        m_pChallengeList->SetItemText(index, COLUMN_COMPLETED, &completed);

        const std::string status_text = NMS_DailifyerStatusText(c.status, c.lockout_seconds);
        CXStr status(status_text.c_str());
        m_pChallengeList->SetItemText(index, COLUMN_STATUS, &status);
        m_pChallengeList->SetItemColor(index, COLUMN_STATUS, NMS_DailifyerStatusColor(c.status));

        m_pChallengeList->SetItemData(index, (uint32_t)i);
    }

    if (m_pChallengeList->Items > 0)
        m_pChallengeList->SetCurSel(0);

    UpdateSelection();
}

void DailifyerWnd::UpdateSelection()
{
    const Challenge* c = GetSelectedChallenge();
    const DailifyerStatus status = c ? (DailifyerStatus)c->status : DailifyerStatus::LockedOut;

    // The server checks everything again; the buttons only reflect what it reported.
    const bool can_challenge = c && (status == DailifyerStatus::Available || status == DailifyerStatus::InProgress);
    const bool can_plunder = c && status == DailifyerStatus::Completed;

    if (m_pObjectiveLabel)
    {
        CXStr text(c ? c->objective.c_str() : "Select a challenge.");
        m_pObjectiveLabel->SetWindowTextA(text);
    }

    if (m_pChallengeButton)
    {
        ((PCSIDLWND)m_pChallengeButton)->Enabled = can_challenge ? 1 : 0;

        CXStr label(status == DailifyerStatus::InProgress ? "Enter Challenge" : "Accept Challenge");
        ((CXWnd*)m_pChallengeButton)->SetWindowTextA(label);
    }

    if (m_pPlunderButton)
        ((PCSIDLWND)m_pPlunderButton)->Enabled = can_plunder ? 1 : 0;
}

const DailifyerWnd::Challenge* DailifyerWnd::GetSelectedChallenge() const
{
    if (!m_pChallengeList)
        return nullptr;

    const int sel = m_pChallengeList->GetCurSel();
    if (sel < 0)
        return nullptr;

    const uint32_t i = m_pChallengeList->GetItemData(sel);
    if (i >= m_challenges.size())
        return nullptr;

    return &m_challenges[i];
}

void DailifyerWnd::SendRequest(uint8_t action)
{
    const Challenge* c = GetSelectedChallenge();
    if (!c)
        return;

    DailifyerRequest_Struct req;
    memset(&req, 0, sizeof(req));
    req.npc_id = m_npcId;
    req.challenge_id = c->id;
    req.action = action;

    SendEQMessage(OP_DAILIFYER_REQUEST, &req, sizeof(req));
    ((CXWnd*)this)->Show(false, false);
}

int DailifyerWnd::WndNotification(CXWnd* pWnd, unsigned int Message, void* data)
{
    if (Message == XWM_LCLICK)
    {
        if (m_pChallengeList && pWnd == (CXWnd*)m_pChallengeList)
            UpdateSelection();
        else if (m_pChallengeButton && pWnd == (CXWnd*)m_pChallengeButton)
            SendRequest((uint8_t)DailifyerAction::Challenge);
        else if (m_pPlunderButton && pWnd == (CXWnd*)m_pPlunderButton)
            SendRequest((uint8_t)DailifyerAction::Plunder);
    }

    return CSidlScreenWnd::WndNotification(pWnd, Message, data);
}
