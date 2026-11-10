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
#include "waypoint_window.h"
#include "dailifyer_window.h"
#include "pet_window.h"

char *OurCaption = "Edge is loading...";

// NMS: Tear down every window we built from a SIDL template.
//
// CleanGameUI (camp to char select) and ReloadUI (/loadskin) destroy EQ's UI. Our
// custom windows are CSidlScreenWnds registered with EQ's window manager, so they go
// with it -- but the statics that point at them were never cleared, leaving pointers
// that are stale yet non-NULL. Nothing noticed, because WaypointsWnd::Shutdown ran only
// from ShutdownMQ2Windows (DLL unload). The result was a crash on both paths --
// "Resetting game UI." followed by an access violation inside ntdll's heap, and
// `if (!s_instance)` failing to rebuild the window on the next login, so gamestate 253
// (LOGGINGIN) called Show() on freed memory.
//
// Destroying them HERE, before the trampoline, is the fix: the windows are still valid,
// and ~CCustomWnd -> ~CSidlScreenWnd deregisters from EQ's manager, so EQ never sees
// them and cannot double-free. Each window re-creates itself on demand afterwards.
// WaypointsWnd and DailifyerWnd are the SIDL-template windows in the build -- any new one
// must be added here.
//
// PetWindow is a second, subtler case: it does not own a window, but it caches pointers
// INTO EQ's pet info window (and the gauges it builds there) and gates re-locating them
// on m_initialized. It cleared those on gamestate change only -- and a /loadskin never
// changes gamestate -- so after a UI reload OnPulse kept writing to freed gauges and
// calling through their dead vftables. Any code that caches an EQ window pointer has to
// drop it here.
static void NMS_DestroyCustomWindows()
{
    WaypointsWnd::Shutdown();
    DailifyerWnd::Shutdown();

    if (PetWindow* pw = PetWindow::GetInstance()) {
        pw->ResetUI();
    }
}

class CDisplayHook
{
public:
    VOID CleanUI_Trampoline(VOID);
    VOID CleanUI_Detour(VOID)
    {
        NMS_DestroyCustomWindows();
        DebugTry(CleanUI_Trampoline());
    }

    VOID ReloadUI_Trampoline(BOOL);
    VOID ReloadUI_Detour(BOOL UseINI)
    {
        NMS_DestroyCustomWindows();
        DebugTry(ReloadUI_Trampoline(UseINI));
    }

    /* This function is still in the client; however, it was phased out as of 
    the Omens of War Expansion

    bool GetWorldFilePath_Trampoline(char *, char *);
    bool GetWorldFilePath_Detour(char *Filename, char *FullPath)
    {
        if (!stricmp(FullPath,"bmpwad8.s3d"))
        {
            sprintf(Filename,"%s\\bmpwad8.s3d",gszINIPath);
            if (_access(Filename,0)!=-1)
            {
                return 1;
            }
        }

        bool Ret=GetWorldFilePath_Trampoline(Filename,FullPath);
        return Ret;
    }
    */
}; 

#ifndef ISXEQ

DWORD __cdecl DrawHUD_Trampoline(DWORD,DWORD,DWORD,DWORD); 
DWORD __cdecl DrawHUD_Detour(DWORD a,DWORD b,DWORD c,DWORD d) 
{ 
    DrawHUDParams[0]=a;
    DrawHUDParams[1]=b;
    DrawHUDParams[2]=c;
    DrawHUDParams[3]=d;
    if (gbHUDUnderUI || gbAlwaysDrawMQHUD)
        return 0;
    int Ret= DrawHUD_Trampoline(a,b,c,d);
    //PluginsDrawHUD();
    if (HMODULE hmEQPlayNice=GetModuleHandle("EQPlayNice.dll"))
    {
        if (fMQPulse pEQPlayNicePulse=(fMQPulse)GetProcAddress(hmEQPlayNice,"Compat_DrawIndicator"))
            pEQPlayNicePulse();
    }
    return Ret;
} 

void DrawHUD()
{
    if (gbAlwaysDrawMQHUD || (gGameState==GAMESTATE_INGAME && gbHUDUnderUI && gbShowNetStatus))
    {
        if (DrawHUDParams[0] && gGameState==GAMESTATE_INGAME && gbShowNetStatus)
        {
            DrawHUD_Trampoline(DrawHUDParams[0],DrawHUDParams[1],DrawHUDParams[2],DrawHUDParams[3]);
            DrawHUDParams[0]=0;
        }
        if (HMODULE hmEQPlayNice=GetModuleHandle("EQPlayNice.dll"))
        {
            if (fMQPulse pEQPlayNicePulse=(fMQPulse)GetProcAddress(hmEQPlayNice,"Compat_DrawIndicator"))
                pEQPlayNicePulse();
        }

    }
    else
        DrawHUDParams[0]=0;
}

VOID DrawHUDText(PCHAR Text, DWORD X, DWORD Y, DWORD Argb, DWORD Size)
{

    DWORD sX=((PCXWNDMGR)pWndMgr)->ScreenExtentX;
    DWORD sY=((PCXWNDMGR)pWndMgr)->ScreenExtentY;

    CTextureFont* pFont=0;
    DWORD* ppDWord=(DWORD*)((PCXWNDMGR)pWndMgr)->font_list_ptr;
    if (ppDWord[1]<=2)
    {
        pFont=(CTextureFont*)ppDWord[0];
    }
    else
    {
        pFont=(CTextureFont*)ppDWord[2];
    }
    if(Size!=2 && Size<12)
        pFont->Size=Size;
    pFont->DrawWrappedText(&CXStr((char*)Text),X,Y,sX-X,&CXRect(X,Y,sX,sY),Argb,1,0);
    pFont->Size=2; // reset back to 2 or it screws up other HUD sizes
}
#endif

class EQ_LoadingSHook
{
public:

    VOID SetProgressBar_Trampoline(int,char const *);
    VOID SetProgressBar_Detour(int A,char const *B)
    {
            SetProgressBar_Trampoline(A,B);
    }
};

//DETOUR_TRAMPOLINE_EMPTY(bool CDisplayHook::GetWorldFilePath_Trampoline(char *, char *)); 
DETOUR_TRAMPOLINE_EMPTY(VOID EQ_LoadingSHook::SetProgressBar_Trampoline(int, char const *)); 
DETOUR_TRAMPOLINE_EMPTY(DWORD DrawHUD_Trampoline(DWORD,DWORD,DWORD,DWORD)); 
DETOUR_TRAMPOLINE_EMPTY(VOID CDisplayHook::CleanUI_Trampoline(VOID)); 
DETOUR_TRAMPOLINE_EMPTY(VOID CDisplayHook::ReloadUI_Trampoline(BOOL)); 

VOID InitializeDisplayHook()
{
    DebugSpew("Initializing Display Hooks");

    EzDetour(CDisplay__CleanGameUI,&CDisplayHook::CleanUI_Detour,&CDisplayHook::CleanUI_Trampoline);
    EzDetour(CDisplay__ReloadUI,&CDisplayHook::ReloadUI_Detour,&CDisplayHook::ReloadUI_Trampoline);
    //EzDetour(CDisplay__GetWorldFilePath,&CDisplayHook::GetWorldFilePath_Detour,&CDisplayHook::GetWorldFilePath_Trampoline);
#ifndef ISXEQ
   // EzDetour(DrawNetStatus,DrawHUD_Detour,DrawHUD_Trampoline);
#endif
    EzDetour(EQ_LoadingS__SetProgressBar,&EQ_LoadingSHook::SetProgressBar_Detour,&EQ_LoadingSHook::SetProgressBar_Trampoline);
}

VOID ShutdownDisplayHook()
{
    DebugSpew("Shutting down Display Hooks");

    RemoveDetour(CDisplay__CleanGameUI);
    RemoveDetour(CDisplay__ReloadUI);
#ifndef ISXEQ
    RemoveDetour(DrawNetStatus);
#endif
    RemoveDetour(EQ_LoadingS__SetProgressBar);
    //RemoveDetour(CDisplay__GetWorldFilePath);
}
