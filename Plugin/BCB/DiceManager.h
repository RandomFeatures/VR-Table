#ifndef DiceManagerH
#define DiceManagerH

#include "dice.h"

TfrmDice* DllMyForm;
extern "C" __declspec(dllexport) __stdcall void InitPlugin(THandle *AppHand);

#endif