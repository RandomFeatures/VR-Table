//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "dice.h"

#include <iostream.h>

//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "cspin"
#pragma resource "*.dfm"
TfrmDice *frmDice;
//---------------------------------------------------------------------------
__fastcall TfrmDice::TfrmDice(TComponent* Owner)
    : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TfrmDice::Button2Click(TObject *Sender)
{
 Close();
}
//---------------------------------------------------------------------------

void __fastcall TfrmDice::btnd4Click(TObject *Sender)
{
int roll;

    roll = 0;
    for (int i = 1; i == d4->Value; i++)
        {
            roll = roll + random(4)+ 1;
        }
  mmoRecord->Lines->Add("Dice|Myra|"+ IntToStr(d4->Value)+ "d4 "+"+ "+IntToStr(d4plus->Value)+"  Result: " + IntToStr(roll + d4plus->Value));

}
//---------------------------------------------------------------------------

void __fastcall TfrmDice::btnd6Click(TObject *Sender)
{
int roll;
    roll = 0;
    for (int i = 1; i == d6->Value; i++)
        {
            roll = roll + random(6)+ 1;
        }
  mmoRecord->Lines->Add("Dice|Myra|"+ IntToStr(d6->Value)+ "d6 "+"+ "+IntToStr(d6plus->Value)+"  Result: " + IntToStr(roll + d6plus->Value));


}
//---------------------------------------------------------------------------

void __fastcall TfrmDice::btnd8Click(TObject *Sender)
{
int roll;
    roll = 0;
    for (int i = 1; i == d8->Value; i++)
        {
            roll = roll + random(8)+ 1;
        }
  mmoRecord->Lines->Add("Dice|Myra|"+ IntToStr(d8->Value)+ "d8 "+"+ "+IntToStr(d8plus->Value)+"  Result: " + IntToStr(roll + d8plus->Value));


}
//---------------------------------------------------------------------------

void __fastcall TfrmDice::btnd10Click(TObject *Sender)
{
int roll;
    roll = 0;
    for (int i = 1; i == d10->Value; i++)
        {
            roll = roll + random(10)+ 1;
        }
  mmoRecord->Lines->Add("Dice|Myra|"+ IntToStr(d10->Value)+ "d10 "+"+ "+IntToStr(d10plus->Value)+"  Result: " + IntToStr(roll + d10plus->Value));


}
//---------------------------------------------------------------------------

void __fastcall TfrmDice::btnd12Click(TObject *Sender)
{
int roll;
    roll = 0;
    for (int i = 1; i == d12->Value; i++)
        {
            roll = roll + random(12)+ 1;
        }
  mmoRecord->Lines->Add("Dice|Myra|"+ IntToStr(d12->Value)+ "d12 "+"+ "+IntToStr(d12plus->Value)+"  Result: " + IntToStr(roll + d12plus->Value));


}
//---------------------------------------------------------------------------

void __fastcall TfrmDice::btnd20Click(TObject *Sender)
{
int roll;
    roll = 0;
    for (int i = 1; i == d20->Value; i++)
        {
            roll = roll + random(20)+ 1;
        }
  mmoRecord->Lines->Add("Dice|Myra|"+ IntToStr(d20->Value)+ "d20 "+"+ "+IntToStr(d20plus->Value)+"  Result: " + IntToStr(roll + d20plus->Value));


}
//---------------------------------------------------------------------------

void __fastcall TfrmDice::btnd100Click(TObject *Sender)
{
int roll;
    roll = 0;
    for (int i = 1; i == d100->Value; i++)
        {
            roll = roll + random(100)+ 1;
        }
  mmoRecord->Lines->Add("Dice|Myra|"+ IntToStr(d100->Value)+ "d100 "+"+ "+IntToStr(d100plus->Value)+"  Result: " + IntToStr(roll + d100plus->Value));


}
//---------------------------------------------------------------------------

void __fastcall TfrmDice::btndcustClick(TObject *Sender)
{
int roll;
    roll = 0;
    for (int i = 1; i == d100->Value; i++)
        {
            roll = roll + random(StrToInt(custvalue->Text))+ 1;
        }
  mmoRecord->Lines->Add("Dice|Myra|"+ IntToStr(dcust->Value)+ custvalue->Text+" + "+IntToStr(dcustplus->Value)+"  Result: " + IntToStr(roll + dcustplus->Value));


}
//---------------------------------------------------------------------------

void __fastcall TfrmDice::Button1Click(TObject *Sender)
{
 mmoRecord->Lines->Clear();
}
//---------------------------------------------------------------------------

void __fastcall TfrmDice::FormShow(TObject *Sender)
{
 randomize();
}
//---------------------------------------------------------------------------

