//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "DiceManager.h"
#include "dice.h"

USERES("DiceManager.res");
USEFORM("dice.cpp", frmDice);
USELIB("vrtable.lib");
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
    return 1;
}
//---------------------------------------------------------------------------
//MyDllClass::MyDllClass()
//{
//}

//void MyDllClass::CreateAForm()
//{
//    DllMyForm = new TfrmDice(Application);
//    DllMyForm->Left = 0;
//    DllMyForm->Height = 163;
//    DllMyForm->Top = Screen->Height - DllMyForm2->Height -28;
//    DllMyForm->Width = Screen->Width;
//    DllMyForm->Show();
//}
//---------------------------------------------------------------------------
void __stdcall InitPlugin(THandle *AppHand)
{

   // Application->Handle = *AppHand;

    DllMyForm = new TfrmDice(Application);
    DllMyForm->Left = 0;
    DllMyForm->Height = 163;
    DllMyForm->Top = Screen->Height - DllMyForm->Height -28;
    DllMyForm->Width = Screen->Width;
    DllMyForm->Show();
}
