/*****************************************************************************
MQ2Main.dll: MacroQuest2's extension DLL for EverQuest
Copyright (C) 2002-2003 Plazmic, 2003-2005 Lax

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License, version 2, as published by
the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
******************************************************************************/
#if !defined(CINTERFACE)
//#error /DCINTERFACE
#endif

#define DBG_SPEW

//#define DEBUG_TRY 1
#include "MQ2Main.h"
#include "FloatingTextManager.h"
#include "multi_pet.h"
#include "pet_window.h"
#include "waypoint_window.h"
#include "dailifyer_window.h"

extern FloatingTextManager* g_pFtm;
BOOL TurnNotDone=FALSE;

extern bool g_pendingSpellBookShow;
extern bool g_spellBookOpenedByScribe;
extern void FirePendingScribeIfReady();
extern void FireCAuthHandshake();
extern bool g_cauth_sent;

void* hook_vtable_direct(void* object, size_t index, void* new_func)
{
    uintptr_t* vtable = *(uintptr_t**)object;
    uintptr_t original = vtable[index];
    DWORD old_protect;
    VirtualProtect(&vtable[index], sizeof(uintptr_t), PAGE_EXECUTE_READWRITE, &old_protect);
    vtable[index] = (uintptr_t)new_func;
    VirtualProtect(&vtable[index], sizeof(uintptr_t), old_protect, &old_protect);
    return (void*)original;
}

typedef int (__fastcall *CCombatAbilityWnd__OnProcessFrame_t)(CCombatAbilityWnd* pThis, void* pEdx);
CCombatAbilityWnd__OnProcessFrame_t CCombatAbilityWnd__OnProcessFrame_Trampoline = nullptr;
bool g_combatAbilityWndHooked = false;

int __fastcall OnProcessFrame_Detour(CCombatAbilityWnd* pThis, void* pEdx)
{
    static bool firstCall = true;
    firstCall = false; // suppress unused warning

    // "Active disc" = buff with CARecastTimerID >= 20 (both scans below and the label block).
    // Only NMSDiscTimers_ApplyBands() ever writes values >= 20 (true discs from
    // nms_disc_bands.h); regular spells keep their stock linked-recast timers 1..19
    // (Divine Aura 15, Primal Avatar 3, ...) and must not match, or every such buff
    // renders as a running discipline in the Combat Abilities window.

    BYTE originalSpawnClass = 0;
    DWORD originalCI2Class = 0;
    bool spoofed = false;
    PCHARINFO2 pCI2 = GetCharInfo2();

    __try {
        if (pLocalPlayer && pCI2) {
            PSPELL pActiveDisc = nullptr;
            // Scan regular buffs
            for (int i = 0; i < NUM_LONG_BUFFS; i++) {
                LONG spellID = pCI2->Buff[i].SpellID;
                if (spellID > 0) {
                    PSPELL pSpell = GetSpellByID(spellID);
                    if (pSpell && pSpell->CARecastTimerID >= 20 && pSpell->CARecastTimerID != 0xFFFFFFFF) {
                        pActiveDisc = pSpell;
                        break;
                    }
                }
            }

            // Scan short buffs
            if (!pActiveDisc) {
                for (int i = 0; i < 0x37; i++) {
                    LONG spellID = pCI2->ShortBuff[i].SpellID;
                    if (spellID > 0) {
                        PSPELL pSpell = GetSpellByID(spellID);
                        if (pSpell && pSpell->CARecastTimerID >= 20 && pSpell->CARecastTimerID != 0xFFFFFFFF) {
                            pActiveDisc = pSpell;
                            break;
                        }
                    }
                }
            }

            if (pActiveDisc) {
                extern uint32_t g_cauth_bitmask;
                BYTE targetClass = 0;
                for (int i = 0; i < 16; i++) {
                    BYTE lvl = pActiveDisc->Level[i];
                    if (lvl > 0 && lvl < 255) {
                        BYTE classID = i + 1;
                        if (g_cauth_bitmask & (1 << i)) {
                            targetClass = classID;
                            break;
                        }
                        if (targetClass == 0) {
                            targetClass = classID;
                        }
                    }
                }

                if (targetClass != 0) {
                    originalSpawnClass = ((PSPAWNINFO)pLocalPlayer)->Class;
                    originalCI2Class = pCI2->Class;
                    ((PSPAWNINFO)pLocalPlayer)->Class = targetClass;
                    pCI2->Class = targetClass;
                    spoofed = true;
                }
            }
        }
    } __except (EXCEPTION_EXECUTE_HANDLER) {}

    int result = 0;
    if (CCombatAbilityWnd__OnProcessFrame_Trampoline) {
        result = CCombatAbilityWnd__OnProcessFrame_Trampoline(pThis, pEdx);
    }

    if (spoofed) {
        __try {
            if (pLocalPlayer) {
                ((PSPAWNINFO)pLocalPlayer)->Class = originalSpawnClass;
            }
            if (pCI2) {
                pCI2->Class = originalCI2Class;
            }
        } __except (EXCEPTION_EXECUTE_HANDLER) {}
    }

    // Override the label ourselves (so it doesn't default to "No Effect" when spoofing is inactive during drawing)
    __try {
        if (pLocalPlayer && pCI2) {
            PSPELL pActiveDisc = nullptr;
            // Scan regular buffs
            for (int i = 0; i < NUM_LONG_BUFFS; i++) {
                LONG spellID = pCI2->Buff[i].SpellID;
                if (spellID > 0) {
                    PSPELL pSpell = GetSpellByID(spellID);
                    if (pSpell && pSpell->CARecastTimerID >= 20 && pSpell->CARecastTimerID != 0xFFFFFFFF) {
                        pActiveDisc = pSpell;
                        break;
                    }
                }
            }

            // Scan short buffs
            if (!pActiveDisc) {
                for (int i = 0; i < 0x37; i++) {
                    LONG spellID = pCI2->ShortBuff[i].SpellID;
                    if (spellID > 0) {
                        PSPELL pSpell = GetSpellByID(spellID);
                        if (pSpell && pSpell->CARecastTimerID >= 20 && pSpell->CARecastTimerID != 0xFFFFFFFF) {
                            pActiveDisc = pSpell;
                            break;
                        }
                    }
                }
            }

            CXWnd* pLabel = pThis->GetChildItem("CAW_CombatEffectLabel");
            if (pLabel) {
                CLABELWND* pLabelWnd = (CLABELWND*)pLabel;
                if (pActiveDisc) {
                    SetCXStr(&pLabelWnd->Wnd.WindowText, (PCHAR)pActiveDisc->Name);
                } else {
                    SetCXStr(&pLabelWnd->Wnd.WindowText, (PCHAR)"No Effect");
                }
            }
        }
    } __except (EXCEPTION_EXECUTE_HANDLER) {}

    return result;
}

typedef int (__fastcall *CTrackingWnd__OnProcessFrame_t)(CTrackingWnd* pThis, void* pEdx);
CTrackingWnd__OnProcessFrame_t CTrackingWnd__OnProcessFrame_Trampoline = nullptr;
bool g_trackingWndHooked = false;

int __fastcall CTrackingWnd__OnProcessFrame_Detour(CTrackingWnd* pThis, void* pEdx)
{
    extern uint32_t g_cauth_bitmask;
    BYTE originalSpawnClass = 0;
    DWORD originalCI2Class = 0;
    bool spoofed = false;
    PCHARINFO2 pCI2 = GetCharInfo2();

    __try {
        if (pLocalPlayer && pCI2 && (g_cauth_bitmask & 0x08u)) // Ranger class (Bit 3) = 1 << 3 = 8
        {
            originalSpawnClass = ((PSPAWNINFO)pLocalPlayer)->Class;
            originalCI2Class = pCI2->Class;
            ((PSPAWNINFO)pLocalPlayer)->Class = 4; // Ranger
            pCI2->Class = 4; // Ranger
            spoofed = true;
        }
    } __except (EXCEPTION_EXECUTE_HANDLER) {}

    int result = 0;
    if (CTrackingWnd__OnProcessFrame_Trampoline) {
        result = CTrackingWnd__OnProcessFrame_Trampoline(pThis, pEdx);
    }

    if (spoofed) {
        __try {
            if (pLocalPlayer) {
                ((PSPAWNINFO)pLocalPlayer)->Class = originalSpawnClass;
            }
            if (pCI2) {
                pCI2->Class = originalCI2Class;
            }
        } __except (EXCEPTION_EXECUTE_HANDLER) {}
    }

    return result;
}

typedef int (__fastcall *CTrackingWnd__WndNotification_t)(CTrackingWnd* pThis, void* pEdx, CXWnd* sender, uint32_t message, void* data);
CTrackingWnd__WndNotification_t CTrackingWnd__WndNotification_Trampoline = nullptr;

int __fastcall CTrackingWnd__WndNotification_Detour(CTrackingWnd* pThis, void* pEdx, CXWnd* sender, uint32_t message, void* data)
{
    extern uint32_t g_cauth_bitmask;
    BYTE originalSpawnClass = 0;
    DWORD originalCI2Class = 0;
    bool spoofed = false;
    PCHARINFO2 pCI2 = GetCharInfo2();

    __try {
        if (pLocalPlayer && pCI2 && (g_cauth_bitmask & 0x08u)) // Ranger class (Bit 3) = 1 << 3 = 8
        {
            originalSpawnClass = ((PSPAWNINFO)pLocalPlayer)->Class;
            originalCI2Class = pCI2->Class;
            ((PSPAWNINFO)pLocalPlayer)->Class = 4; // Ranger
            pCI2->Class = 4; // Ranger
            spoofed = true;
        }
    } __except (EXCEPTION_EXECUTE_HANDLER) {}

    int result = 0;
    if (CTrackingWnd__WndNotification_Trampoline) {
        result = CTrackingWnd__WndNotification_Trampoline(pThis, pEdx, sender, message, data);
    }

    if (spoofed) {
        __try {
            if (pLocalPlayer) {
                ((PSPAWNINFO)pLocalPlayer)->Class = originalSpawnClass;
            }
            if (pCI2) {
                pCI2->Class = originalCI2Class;
            }
        } __except (EXCEPTION_EXECUTE_HANDLER) {}
    }

    return result;
}

void FixAllSpellRecastTimers()
{
    static bool done = false;
    if (done) return;
    if (gGameState != GAMESTATE_INGAME || !pSpellMgr) return;

    int count = 0;
    for (DWORD i = 1; i < TOTAL_SPELL_COUNT; i++) {
        PSPELL pSpell = GetSpellByID(i);
        if (pSpell) {
            if (pSpell->CARecastTimerID > 20 && pSpell->CARecastTimerID != 0xFFFFFFFF) {
                DWORD oldTimer = pSpell->CARecastTimerID;
                uint32_t rem = oldTimer % 20;
                pSpell->CARecastTimerID = (rem == 0) ? 20 : rem;
                count++;
            }
        }
    }
    done = true;
}

// NMS: Global variables for sneak class-spoof so they can be accessed from InterpretCmd detour
BYTE g_savedClass = 0;
BYTE g_savedCI2Class = 0;
bool g_overrideActive = false;

// NMS: Speed override variables to bypass sneak walk speed penalty
static float s_savedSneakMultiplier = 0.0f;
static bool s_sneakMultiplierOverridden = false;

// NMS: Variables for casting class-spoof
static BYTE s_savedCastingClass = 0;
static BYTE s_savedCastingCI2Class = 0;
static bool s_castingOverrideActive = false;

// Removed IsMovementKeyDown() - class spoofing now runs permanently while sneaking/hiding

void Heartbeat()
{
    FixAllSpellRecastTimers();
    int GameState=GetGameState();
    if (gGameState == GAMESTATE_INGAME && ppCombatAbilityWnd && *ppCombatAbilityWnd && !g_combatAbilityWndHooked)
    {
        CCombatAbilityWnd__OnProcessFrame_Trampoline = (CCombatAbilityWnd__OnProcessFrame_t)hook_vtable_direct(*ppCombatAbilityWnd, 49, (void*)OnProcessFrame_Detour);
        g_combatAbilityWndHooked = true;
    }

    if (gGameState == GAMESTATE_INGAME && ppTrackingWnd && *ppTrackingWnd && !g_trackingWndHooked)
    {
        CTrackingWnd__OnProcessFrame_Trampoline = (CTrackingWnd__OnProcessFrame_t)hook_vtable_direct(*ppTrackingWnd, 49, (void*)CTrackingWnd__OnProcessFrame_Detour);
        CTrackingWnd__WndNotification_Trampoline = (CTrackingWnd__WndNotification_t)hook_vtable_direct(*ppTrackingWnd, 34, (void*)CTrackingWnd__WndNotification_Detour);
        g_trackingWndHooked = true;
    }

    if (GameState!=-1)
    {
        if ((DWORD)GameState!=gGameState)
        {
			SetMapGameState(GameState);
            gGameState=GameState;
        }
    }
    UpdateMQ2SpawnSort();

    if (GameState != GAMESTATE_INGAME)
    {
        if (g_overrideActive) {
            g_overrideActive = false;
            g_savedClass = 0;
            g_savedCI2Class = 0;
            OutputDebugStringA("[NMS-Stealth] Reset: Deactivated override due to zoning\n");
        }
        s_sneakMultiplierOverridden = false;
        s_savedSneakMultiplier = 0.0f;

        if (s_castingOverrideActive) {
            s_castingOverrideActive = false;
            s_savedCastingClass = 0;
            s_savedCastingCI2Class = 0;
            OutputDebugStringA("[NMS-Casting] Reset: Deactivated override due to zoning\n");
        }
    }

    FireCAuthHandshake(); // Deferred CAuth — main thread, safe to send

    // NMS: keep discipline timer-bands applied (native client re-wraps CARecastTimerID
    // mod 20 on spell load; this restores the >=20 banded IDs so classes stay separated).
    {
        extern void NMSDiscTimers_MaintainBands();
        NMSDiscTimers_MaintainBands();
    }

    if (MultiPet* mp = MultiPet::GetInstance())
        mp->OnPulse();
    if (PetWindow* pw = PetWindow::GetInstance())
        pw->OnPulse();
    if (WaypointsWnd* ww = WaypointsWnd::GetInstance())
        ww->OnPulse();

    // NMS: Refresh Alt Currency list when inventory window is opened
    static bool s_lastInventoryVisible = false;
    if (gGameState == GAMESTATE_INGAME && pLocalPlayer && ppInventoryWnd && *ppInventoryWnd)
    {
        bool isVisible = ((CXWnd*)*ppInventoryWnd)->IsReallyVisible();
        if (isVisible && !s_lastInventoryVisible)
        {
            CXWnd* pButton = ((CSidlScreenWnd*)*ppInventoryWnd)->GetChildItem("AltCurr_DisplayMissingButton");
            if (pButton)
            {
                ((CXWnd*)*ppInventoryWnd)->WndNotification(pButton, XWM_LCLICK, nullptr);
            }
        }
        s_lastInventoryVisible = isVisible;
    }
    else
    {
        s_lastInventoryVisible = false;
    }

    // NMS: Sneak class-spoof — force Class = Rogue every frame while sneaking.
    // The RoF2 client checks pLocalPlayer->Class before deciding whether to cancel
    // sneak on movement. For multiclass characters it sees the wrong base class
    // (e.g. Bard) and sends CancelSneakHide packets. By forcing Class=Rogue while
    // sneaking we stop those packets from being sent in the first place.
    // When the spellbook is open, we restore the original class so spellbook memorization works.
    extern uint32_t g_cauth_bitmask;

    if (pLocalPlayer && GameState == GAMESTATE_INGAME)
    {
        PSPAWNINFO pPlayer = (PSPAWNINFO)pLocalPlayer;
        PCHARINFO2  pCI2   = GetCharInfo2();

        // NMS: Clear client-side blindness flag (offset 0x0428) to prevent screen blackout (e.g. from Berserker's Blinding Fury)
        *(BYTE*)((DWORD)pPlayer + 0x0428) = 0;

        // NMS 2026-07-15: Sneak/Hide full-speed override (client-side; no class mutation).
        // Pairs with the static move-break patch in Hooks.cpp (0x45EA0F NOP) that lets the
        // client persist Hide through movement while sneaking regardless of visible class.
        // Because the client IS told it's sneaking (server sends the Sneak appearance), it
        // applies the walk-speed cap; walk speed = 0.45999f * SneakMult(+0x11C8), so setting
        // the multiplier to RunSpeed/0.45999f makes sneak/hide move at full run speed.
        // Only touches +0x11C8 -- NOT the UI/casting class fields -- so no side effects.
        if (g_cauth_bitmask & 0x100u) // 0x100 = Rogue bit (class 9)
        {
            bool isSneaking = (pPlayer->Sneak != 0 || pPlayer->HideMode != 0);
            float* pSneakMult = (float*)((DWORD)pPlayer + 0x11c8);
            if (isSneaking)
            {
                if (!s_sneakMultiplierOverridden)
                {
                    s_savedSneakMultiplier = *pSneakMult;
                    s_sneakMultiplierOverridden = true;
                }
                *pSneakMult = pPlayer->RunSpeed / 0.45999f;
            }
            else if (s_sneakMultiplierOverridden)
            {
                *pSneakMult = s_savedSneakMultiplier;
                s_sneakMultiplierOverridden = false;
                s_savedSneakMultiplier = 0.0f;
            }
        }

        // NMS: Casting class-spoof for non-bard spells
        bool isCurrentlyCasting = (pPlayer->CastingData.SpellID != 0xFFFFFFFF && pPlayer->CastingData.SpellID != 0);
        bool shouldCastingSpoof = false;
        BYTE castingTargetClass = 0;

        if (isCurrentlyCasting && pPlayer->CastingData.SpellSlot != 0xFF)
        {
            PSPELL pSpell = GetSpellByID(pPlayer->CastingData.SpellID);
            if (pSpell)
            {
                // Only spoof non-bard spells (where Level[7] corresponds to Bard level = 255)
                if (pSpell->Level[7] == 255)
                {
                    // Find a caster class from the player's multiclass bitmask that can cast this spell
                    for (int i = 0; i < 16; i++)
                    {
                        if (g_cauth_bitmask & (1 << i))
                        {
                            BYTE reqLevel = pSpell->Level[i];
                            if (reqLevel > 0 && reqLevel < 255)
                            {
                                castingTargetClass = i + 1;
                                shouldCastingSpoof = true;
                                break;
                            }
                        }
                    }
                }
            }
        }

        if (shouldCastingSpoof)
        {
            if (!s_castingOverrideActive)
            {
                // Save original class (referencing the saved class if sneak spoof is also active)
                s_savedCastingClass = g_overrideActive ? g_savedClass : pPlayer->Class;
                s_savedCastingCI2Class = g_overrideActive ? g_savedCI2Class : (pCI2 ? (BYTE)pCI2->Class : 0);
                s_castingOverrideActive = true;
                char dbg[256];
                sprintf_s(dbg, "[NMS-Casting] Activation: Spoofing class to %d for spell %d\n", castingTargetClass, pPlayer->CastingData.SpellID);
                OutputDebugStringA(dbg);
            }
            pPlayer->Class = castingTargetClass;
            if (pCI2) pCI2->Class = castingTargetClass;
        }
        else if (s_castingOverrideActive)
        {
            pPlayer->Class = s_savedCastingClass;
            if (pCI2 && s_savedCastingCI2Class) pCI2->Class = s_savedCastingCI2Class;
            s_castingOverrideActive = false;
            s_savedCastingClass = s_savedCastingCI2Class = 0;
            OutputDebugStringA("[NMS-Casting] Deactivation: Restored original class\n");
        }

        // NMS 2026-07-21: global cooldown removal. On a completed cast the client
        // stamps SpellCooldownETA (SPAWNINFO+0x3CC) with the spell's recovery time and greys ALL
        // gems until it passes; CCastSpellWnd::RefreshSpellGemButtons (0x647EA0) re-reads it every
        // frame alongside the per-gem SpellGemETA array (+0x2E8). Zeroing it whenever no cast is
        // in flight leaves only the finished spell's own gem recast running -- next spell can
        // start immediately. While casting we must NOT touch it: CastSpell (0x43A830) uses it to
        // hold the other gems locked until the cast resolves.
        if (!isCurrentlyCasting)
        {
            DWORD* pSpellCooldownETA = (DWORD*)((DWORD)pPlayer + 0x3CC);
            if (*pSpellCooldownETA != 0)
                *pSpellCooldownETA = 0;
        }
    }

    // Deferred sit after right-click scribe, requested by CInvSlot::HandleRButtonUp detour.
    // The book is already opened synchronously in the hook via InterpretCmd("/book").
    if (g_pendingSpellBookShow)
    {
        g_pendingSpellBookShow = false;
        if (ppEverQuest && pEverQuest && pLocalPlayer
            && ((PSPAWNINFO)pLocalPlayer)->StandState != STANDSTATE_SIT)
        {
            pEverQuest->InterpretCmd(pLocalPlayer, "/sit");
        }
        g_spellBookOpenedByScribe = true;
    }

    // Close the spell book when the player stands up after scribing.
    if (g_spellBookOpenedByScribe && pLocalPlayer)
    {
        if (((PSPAWNINFO)pLocalPlayer)->StandState != STANDSTATE_SIT)
        {
            g_spellBookOpenedByScribe = false;
            if (ppSpellBookWnd && pSpellBookWnd)
                ((CXWnd*)pSpellBookWnd)->Show(false, true, false);
        }
    }

    // Scribe timer: fire deferred server scribing once the timer expires.
    FirePendingScribeIfReady();

    // NMS: Update window title to show character name in taskbar (multibox QoL)
    // Throttled: only runs once every 5 seconds to avoid overhead.
    static DWORD s_lastTitleUpdate = 0;
    DWORD now = GetTickCount();
    if (now - s_lastTitleUpdate > 5000)
    {
        s_lastTitleUpdate = now;
        if (pLocalPlayer)
        {
            const char* charName = ((PSPAWNINFO)pLocalPlayer)->Name;
            if (charName && charName[0])
            {
                // Find the EQ window belonging to this process (safe for multiboxing)
                struct WndFinder {
                    static BOOL CALLBACK Enum(HWND h, LPARAM lp) {
                        DWORD pid = 0;
                        ::GetWindowThreadProcessId(h, &pid);
                        if (pid == ::GetCurrentProcessId() && ::IsWindowVisible(h)) {
                            char cls[64] = {};
                            ::GetClassNameA(h, cls, sizeof(cls));
                            // Skip IME and system windows that might be hidden but technically "visible"
                            if (strcmp(cls, "MSCTFIME UI") != 0 && strcmp(cls, "IME") != 0 && strcmp(cls, "Default IME") != 0) {
                                *(HWND*)lp = h;
                                return FALSE;
                            }
                        }
                        return TRUE;
                    }
                };
                static HWND s_eqHwnd = nullptr;
                if (!s_eqHwnd || !::IsWindow(s_eqHwnd))
                    ::EnumWindows(WndFinder::Enum, (LPARAM)&s_eqHwnd);
                if (s_eqHwnd) {
                    char title[256];
                    // Build class string from multiclass bitmask
                    extern uint32_t g_cauth_bitmask;
                    char classes[64] = {};
                    if (g_cauth_bitmask != 0) {
                        bool first = true;
                        for (int i = 0; i < 16; i++) {
                            if (g_cauth_bitmask & (1 << i)) {
                                if (!first) strcat_s(classes, sizeof(classes), "/");
                                strcat_s(classes, sizeof(classes), pEverQuest->GetClassThreeLetterCode(i + 1));
                                first = false;
                            }
                        }
                    } else {
                        // Bitmask not received yet — fall back to primary class
                        strcat_s(classes, sizeof(classes), pEverQuest->GetClassThreeLetterCode(((PSPAWNINFO)pLocalPlayer)->Class));
                    }
                    sprintf_s(title, sizeof(title), "EverQuest - %s [%s]", charName, classes);
                    ::SetWindowTextA(s_eqHwnd, title);
                }
            }
        }
    }
}

bool isFtmPluginInit = false;
bool addedTestText = false;
extern IDirect3DDevice9* g_pDevice;
#ifndef ISXEQ_LEGACY
// *************************************************************************** 
// Function:    ProcessGameEvents 
// Description: Our ProcessGameEvents Hook
// *************************************************************************** 
BOOL Trampoline_ProcessGameEvents(VOID); 
BOOL Detour_ProcessGameEvents(VOID) 
{ 
	if(!isFtmPluginInit)
		InitializeFloatingTextPlugin();

    Heartbeat();
#ifdef ISXEQ
    if (!pISInterface->ScriptEngineActive()) 
        pISInterface->LavishScriptPulse();
#endif
    return Trampoline_ProcessGameEvents();
}

DETOUR_TRAMPOLINE_EMPTY(BOOL Trampoline_ProcessGameEvents(VOID)); 
class CEverQuestHook {
public:
    VOID EnterZone_Trampoline(PVOID pVoid);
    VOID EnterZone_Detour(PVOID pVoid)
    {
        EnterZone_Trampoline(pVoid);
        gZoning = TRUE;
        WereWeZoning = TRUE;
        g_cauth_sent = false; // re-arm auth for new zone
    }

    VOID SetGameState_Trampoline(DWORD GameState);
    VOID SetGameState_Detour(DWORD GameState)
    {
//        DebugSpew("SetGameState_Detour(%d)",GameState);

		SetMapGameState(GameState);
        if (MultiPet* mp = MultiPet::GetInstance())
            mp->OnSetGameState((int)GameState);
        if (PetWindow* pw = PetWindow::GetInstance())
            pw->OnSetGameState((int)GameState);
        if (WaypointsWnd* ww = WaypointsWnd::GetInstance())
            ww->OnSetGameState((int)GameState);
        DailifyerWnd::OnSetGameState((int)GameState);
        SetGameState_Trampoline(GameState);
    }
};

DETOUR_TRAMPOLINE_EMPTY(VOID CEverQuestHook::EnterZone_Trampoline(PVOID));
DETOUR_TRAMPOLINE_EMPTY(VOID CEverQuestHook::SetGameState_Trampoline(DWORD));

void CmdAutoSkill(PSPAWNINFO pChar, PCHAR szLine)
{
    if (!pLocalPlayer) return;

    if (szLine) {
        while (*szLine && isspace(*szLine)) szLine++;
    }

    // Forward to the server's #autoskill command. With no arguments the server answers with
    // its usage text and skill list.
    char szCmd[512];
    if (!szLine || !*szLine) {
        sprintf_s(szCmd, sizeof(szCmd), "#autoskill");
    } else {
        sprintf_s(szCmd, sizeof(szCmd), "#autoskill %s", szLine);
    }
    if (pEverQuest) {
        pEverQuest->InterpretCmd((EQPlayer*)pLocalPlayer, szCmd);
    }
}

void InitializeMQ2Pulse()
{
    EzDetour(ProcessGameEvents,Detour_ProcessGameEvents,Trampoline_ProcessGameEvents);
    EzDetour(CEverQuest__EnterZone,&CEverQuestHook::EnterZone_Detour,&CEverQuestHook::EnterZone_Trampoline);
    EzDetour(CEverQuest__SetGameState,&CEverQuestHook::SetGameState_Detour,&CEverQuestHook::SetGameState_Trampoline);
    AddCommand("/autoskill", CmdAutoSkill);
}

void ShutdownMQ2Pulse()
{
    RemoveCommand("/autoskill");
    if (g_combatAbilityWndHooked && ppCombatAbilityWnd && *ppCombatAbilityWnd && CCombatAbilityWnd__OnProcessFrame_Trampoline)
    {
        hook_vtable_direct(*ppCombatAbilityWnd, 49, (void*)CCombatAbilityWnd__OnProcessFrame_Trampoline);
        g_combatAbilityWndHooked = false;
    }
    if (g_trackingWndHooked && ppTrackingWnd && *ppTrackingWnd)
    {
        if (CTrackingWnd__OnProcessFrame_Trampoline)
        {
            hook_vtable_direct(*ppTrackingWnd, 49, (void*)CTrackingWnd__OnProcessFrame_Trampoline);
        }
        if (CTrackingWnd__WndNotification_Trampoline)
        {
            hook_vtable_direct(*ppTrackingWnd, 34, (void*)CTrackingWnd__WndNotification_Trampoline);
        }
        g_trackingWndHooked = false;
    }
    RemoveDetour((DWORD)ProcessGameEvents);
    RemoveDetour(CEverQuest__EnterZone);
    RemoveDetour(CEverQuest__SetGameState);
}
#endif
