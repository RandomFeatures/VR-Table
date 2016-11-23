//---------------------------------------------------------------------------
#ifndef diceH
#define diceH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "cspin.h"
#include <Buttons.hpp>
#include <ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TfrmDice : public TForm
{
__published:	// IDE-managed Components
    TSplitter *Splitter1;
    TPanel *Panel1;
    TCSpinEdit *d12;
    TEdit *Edit3;
    TCSpinEdit *d20;
    TEdit *Edit7;
    TCSpinEdit *d20plus;
    TCSpinEdit *d12plus;
    TBitBtn *btnd12;
    TBitBtn *btnd20;
    TCSpinEdit *d100;
    TEdit *Edit4;
    TCSpinEdit *d100plus;
    TBitBtn *btnd100;
    TBitBtn *btndcust;
    TCSpinEdit *dcustplus;
    TEdit *custvalue;
    TCSpinEdit *dcust;
    TCSpinEdit *d4;
    TEdit *Edit1;
    TCSpinEdit *d4plus;
    TBitBtn *btnd4;
    TBitBtn *btnd6;
    TCSpinEdit *d6plus;
    TEdit *Edit2;
    TCSpinEdit *d6;
    TCSpinEdit *d8;
    TEdit *Edit5;
    TCSpinEdit *d8plus;
    TBitBtn *btnd8;
    TBitBtn *btnd10;
    TCSpinEdit *d10plus;
    TEdit *Edit6;
    TCSpinEdit *d10;
    TPanel *Panel2;
    TMemo *mmoRecord;
    TPanel *Panel3;
    TButton *Button1;
    TButton *Button2;
    void __fastcall Button2Click(TObject *Sender);
    void __fastcall btnd4Click(TObject *Sender);
    void __fastcall btnd6Click(TObject *Sender);
    void __fastcall btnd8Click(TObject *Sender);
    void __fastcall btnd10Click(TObject *Sender);
    void __fastcall btnd12Click(TObject *Sender);
    void __fastcall btnd20Click(TObject *Sender);
    void __fastcall btnd100Click(TObject *Sender);
    void __fastcall btndcustClick(TObject *Sender);
    void __fastcall Button1Click(TObject *Sender);
    void __fastcall FormShow(TObject *Sender);
private:	// User declarations
public:		// User declarations
    __fastcall TfrmDice(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmDice *frmDice;
//---------------------------------------------------------------------------
#endif
