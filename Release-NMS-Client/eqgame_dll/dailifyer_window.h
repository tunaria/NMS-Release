/**
 * @file dailifyer_window.h
 * @brief DailifyerWnd: the Dailifyer challenge window (Carles Seregwyn in the Bazaar).
 *
 * The server sends the list of challenges with OP_DailifyerWindow (0x140A) when the player hails
 * the NPC; the buttons answer with OP_DailifyerRequest (0x140B). Every rule is decided on the
 * server (Release-NMS-Plugins/NMS_dailifyer_utils.pl): this window only shows what it receives.
 */

#pragma once

#include "MQ2Main.h"

#include <cstdint>
#include <string>
#include <vector>

class DailifyerWnd : public CCustomWnd
{
public:
    DailifyerWnd();
    ~DailifyerWnd();

    int WndNotification(CXWnd* pWnd, unsigned int Message, void* data);

    static void Initialize();
    static void Shutdown();
    static void OnIncomingPacket(uint16_t opcode, void* buf, size_t size);
    static void OnSetGameState(int state);
    static DailifyerWnd* GetInstance();

private:
    struct Challenge
    {
        uint32_t id;
        uint8_t status;
        bool completed;
        uint32_t lockout_seconds;
        std::string name;
        std::string objective;
    };

    bool HandleWindowPacket(void* buf, size_t size);
    void PopulateList();
    void UpdateSelection();
    void SendRequest(uint8_t action);
    const Challenge* GetSelectedChallenge() const;

    static DailifyerWnd* s_instance;

    CXWnd* m_pNPCLabel;
    CListWnd* m_pChallengeList;
    CXWnd* m_pObjectiveLabel;
    CButtonWnd* m_pChallengeButton;
    CButtonWnd* m_pPlunderButton;

    uint32_t m_npcId;
    std::vector<Challenge> m_challenges;
};
