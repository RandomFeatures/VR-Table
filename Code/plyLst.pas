unit plyLst;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, history,
  ComCtrls, ExtCtrls, Menus, strFunctions, Wordcap, DirectX, BigIni, stdctrls,
  ImgList, TreeUtils, VrePlayer, MediaDialogs, ExtDlgs;

const
   IMG_NODE_ROOT = 7;
   IMG_NODE_FILE_CLOSED = 6;
   IMG_NODE_FILE_OPEN = 6;


type
   eNodeType = (ntUnknown,  ntRoot,  ntFile,  ntFolder);

  TfrmPlayerList = class(TForm)
    PopupMenu1: TPopupMenu;
    PrivateMessage1: TMenuItem;
    PlaySound1: TMenuItem;
    ShowPicture1: TMenuItem;
    Lock1: TMenuItem;
    Kick1: TMenuItem;
    MSOfficeCaption1: TMSOfficeCaption;
    PlayMusic1: TMenuItem;
    Timer1: TTimer;
    Timer2: TTimer;
    History1: TMenuItem;
    Status1: TMenuItem;
    Blind1: TMenuItem;
    Def1: TMenuItem;
    Mute1: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    playrList: TListView;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    Button1: TButton;
    tv_eg5: TTreeView;
    Panel3: TPanel;
    OpenDialog1: TMediaOpenDialog;
    OpenDialog2: TMediaOpenDialog;
    ImageList1: TImageList;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure FormResize(Sender: TObject);
    procedure playrListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PrivateMessage1Click(Sender: TObject);
    procedure Kick1Click(Sender: TObject);
    procedure Lock1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure SendPrivateMessage(ReceivingPlayerName, Msg: string);
    procedure SendPrivateAction(ReceivingPlayerName, MsgAction: string);
    procedure PlayMusic1Click(Sender: TObject);
    procedure ShowPicture1Click(Sender: TObject);
    procedure PlaySound1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure playrListDblClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure History1Click(Sender: TObject);
    procedure Blind1Click(Sender: TObject);
    procedure Def1Click(Sender: TObject);
    procedure Mute1Click(Sender: TObject);
    procedure tv_eg5DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tv_eg5DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
    function GetNodeType(  Node : TTreeNode  ) : eNodeType;
    procedure AddNode(  NodeType : eNodeType; sText: String  );
    function IsNodeAllowed(  ParentNode : TTreeNode;
                              NewNodesType : eNodeType
                            ) : boolean;

  public
        PlayerList: TStringList;
        procedure Setup;
        procedure isActive;
        procedure isInActive;
        procedure AddAPlayer(PlayerName: String);
        procedure DeleteAPlayer(PlayerName: String);

    { Public declarations }
  end;

var
  frmPlayerList: TfrmPlayerList;
  pMsg : string;
  T: boolean;
//  PlayrListMemo : TMemo;

implementation

uses Main, chat, sysMessages;


{$R *.DFM}

procedure TfrmPlayerList.FormResize(Sender: TObject);
begin
if frmPlayerList.width < 159 then frmPlayerList.width := 159;
if frmPlayerList.left > (screen.width - frmPlayerList.width) then frmPlayerList.left := (screen.width - frmPlayerList.width);
PlayrList.Columns[0].width := frmPlayerList.width - 20;
end;

procedure TfrmPlayerList.playrListMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if button = mbRight then
if (playrList.selcount > 0) and (MainForm.DXplay1.Opened) and (playrList.Items.Count > 1) then
   PopupMenu1.AutoPopup := true
else
    PopupMenu1.AutoPopup := False;

end;

procedure TfrmPlayerList.PrivateMessage1Click(Sender: TObject);
var
  frmMsg: TfrmDialog;
  frmRcv: TfrmDialog;
  i: Integer;
begin
     if PrivateMessage1.caption = 'Message' then
        begin
             frmMsg := TfrmDialog.Create(Self);
             frmMsg.PageControl1.ActivePage := frmMsg.TabSheet3;
             frmMsg.Caption := 'Private Message for ' + PlayrList.Selected.Caption;
             if frmMsg.ShowModal = mrOk then
             if playrList.ItemFocused.Caption = 'All Players' then
                SendPrivateMessage('DPID_ALLPLAYERS',pMsg)
             else
                SendPrivateMessage(playrList.ItemFocused.Caption,pMsg);

             frmMsg.Free;
             frmMsg := nil;
        end
     else
        if PrivateMessage1.caption = 'Receive' then
           begin
              frmRcv := TfrmDialog.Create(Self);
              frmRcv.PageControl1.ActivePage := frmRcv.TabSheet2;
              i := frmPlayerList.playerList.IndexOf(playrList.ItemFocused.Caption);

              if playrList.ItemFocused.Caption = 'All Players' then
                 frmRcv.label1.caption := 'DPID_ALLPLAYERS'
              else
                 frmRcv.label1.caption := playrList.ItemFocused.Caption;

                frmRcv.mmorcvmsg.text := TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Player_Messages.Strings[0];
                TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Player_Messages.Delete(0);
                if TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Player_Messages.Count = 0 then
                   TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Message_Waiting := false;


             if frmRcv.ShowModal = mrOk then
             frmRcv.Free;
             frmRcv := nil;
           end;
end;

procedure TfrmPlayerList.Setup;
begin
     width := 150;
     Left :=  screen.width - width;
     top := MainForm.top + MainForm.height + 1;
     height := frmChat.height;
     MainForm.PlayerList1.checked := true;
     show;
end;

procedure TfrmPlayerList.isActive;
begin
 playrList.enabled := true;
 playrList.font.color := clBlack;
end;
procedure TfrmPlayerList.isInActive;
begin
 playrList.enabled := false;
 playrList.font.color := clGray;

end;

procedure TfrmPlayerList.AddAPlayer(PlayerName: String);
var
   ListItem: TListItem;
   NewPlayer: TVrePlayer;
begin
{
Create, Player_List, Name, Player_Name, Plater_ID, Setup, Lock
}
     NewPlayer := TVrePlayer.Create(Self);
   //  NewPlayer.Name :=StrTokenAt(PlayerName, '\',0) + StrTokenAt(PlayerName, '\',1);;
     NewPlayer.Player_List := playrList;
     NewPlayer.Player_Name := StrTokenAt(PlayerName, '\',0);
     NewPlayer.Player_ID := StrTokenAt(PlayerName, '\',1);
     NewPlayer.Setup;

     PlayerList.objects[PlayerList.add(NewPlayer.Player_Name)]  := NewPlayer;

     if MainForm.DXPlay1.isHost then
          NewPlayer.Status_Locked := true
     else
         NewPlayer.Status_Locked := false;

     NewPlayer := Nil;

    AddNode(ntFile,PlayerName);
    Button1.Enabled := true;
end;

procedure TfrmPlayerList.DeleteAPlayer(PlayerName: String);
var
i : integer;
DelIndex: integer;
begin

     for I := 0 to frmPlayerList.PlayerList.count - 1 do
         begin
              if TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Player_Id = StrTokenAt(PlayerName, '\',1) then
              begin
                   DelIndex := i;
                   break;
              end;
         end;

     TVrePlayer(frmPlayerList.PlayerList.Objects[DelIndex]).free;

     frmPlayerList.PlayerList.Delete(DelIndex);

     for I := 0 to frmPlayerList.PlayerList.count - 1 do
         begin
               TVrePlayer(frmPlayerList.PlayerList.Objects[i]).ReIndex;
         end;

     for i := 0 to tv_eg5.Items.Count - 1 do
         begin
           if GetNodeType(tv_eg5.Items.Item[i]) = ntFile then
           if tv_eg5.Items.Item[i].text = PlayerName then
              begin
                   tv_eg5.Items.Item[i].Delete;
                   exit;
              end;
         end;
end;


procedure TfrmPlayerList.Kick1Click(Sender: TObject);
begin
//kick a player from the game
    SendPrivateAction(playrList.ItemFocused.Caption,'Kick');

end;

procedure TfrmPlayerList.Lock1Click(Sender: TObject);
var
MsgWaiting: boolean;
indxDelete: integer;
begin
MsgWaiting := false;
indxDelete:= frmPlayerList.PlayerList.IndexOf(playrList.ItemFocused.Caption);


    if TVrePlayer(PlayerList.Objects[indxDelete]).Status_Locked then
       begin//unlock
            TVrePlayer(PlayerList.Objects[indxDelete]).Status_Locked := False;
           frmSysMsg.mmoSysMsg.Lines.Add('Unlocked '+playrList.ItemFocused.caption);
           SendPrivateAction(playrList.ItemFocused.Caption,'Unlock');
       end
    else
        begin   //Lock
            TVrePlayer(frmPlayerList.PlayerList.Objects[indxDelete]).Status_Locked := True;
           frmSysMsg.mmoSysMsg.Lines.Add('Locked '+playrList.ItemFocused.caption);
           SendPrivateAction(playrList.ItemFocused.Caption,'Lock');
        end;
    //Code to tell their machine to lock for a sec
end;

procedure TfrmPlayerList.PopupMenu1Popup(Sender: TObject);
var
i: integer;
MsgWaiting: boolean;
PlyrLocked : boolean;
begin
MsgWaiting:= false;
PlyrLocked := false;


     if playrList.ItemFocused.Caption <> 'All Players' then
        History1.Enabled := true
     else
        History1.Enabled := false;


     if MainForm.DXPlay1.isHost then
        begin
             if playrList.ItemFocused.Caption <> 'All Players' then
                begin
                  Status1.enabled := true;
                  Kick1.enabled := true;
                  Lock1.enabled := true;
                end
             else
                 begin
                  Status1.enabled := false;
                  Kick1.enabled := false;
                  Lock1.enabled := false;
                 end;

             Blind1.checked := false;
             Def1.checked := false;
             Mute1.checked := false;
             Kick1.visible := true;
             lock1.visible := true;
             PlayMusic1.enabled := true;
             PlayMusic1.visible := true;
             Status1.visible := true;
             ShowPicture1.enabled := true;
             PlaySound1.enabled := true;
           end;

            i := frmPlayerList.playerList.IndexOf(playrList.ItemFocused.Caption);
            if i <> -1 then
            begin
                Blind1.Checked := TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Status_Blind;
                Mute1.Checked := TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Status_Mute;
                def1.Checked := TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Status_deaf;
                if TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Status_Locked then
                   Lock1.caption := 'Unlock'
                else
                   lock1.caption := 'Lock';

                if TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Message_Waiting then
                   PrivateMessage1.caption := 'Receive'
                else
                   PrivateMessage1.caption := 'Message';
            end;

end;
procedure TfrmPlayerList.SendPrivateMessage(ReceivingPlayerName, Msg: string);
var
   ReceivingPlayerID : integer;
   SendingPlayerName: String;
   I : integer;
begin
   if ReceivingPlayerName <> 'DPID_ALLPLAYERS' then
      begin
          i := frmPlayerList.playerList.IndexOf(playrList.ItemFocused.Caption);
          ReceivingPlayerID := StrToInt(TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Player_ID);
          TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Chat_History.Add('.................');
          TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Chat_History.Add(MainForm.DXPlay1.LocalPlayer.Name+': ' + Msg);
      end
   else
       begin
            for I := 0 to frmPlayerList.PlayerList.count - 1 do
                begin
                     TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Chat_History.Add('.................');
                     TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Chat_History.Add(StrTokenAt(ReceivingPlayerName, Slash,0)+': ' +Msg);
                end;
       end;

   SendingPlayerName := MainForm.DXPlay1.LocalPlayer.Name + Slash + IntToStr(MainForm.DXPlay1.LocalPlayer.ID);
   if Assigned(SndToOne) then
   if ReceivingPlayerName = 'DPID_ALLPLAYERS' then
       SndToOne(PChar('PrivateMessage' + '|'+SendingPlayerName+'|'+Msg), DPID_ALLPLAYERS)
   else
       SndToOne(PChar('PrivateMessage' + '|'+SendingPlayerName+'|'+Msg), ReceivingPlayerID);
end;



procedure TfrmPlayerList.SendPrivateAction(ReceivingPlayerName, MsgAction: string);
var
   ReceivingPlayerID : Integer;
   SendingPlayerName: String;
   i: integer;
begin
    i := playerList.IndexOf(playrList.ItemFocused.Caption);
    if i <> -1 then
       ReceivingPlayerID := StrToInt(TVrePlayer(PlayerList.Objects[i]).Player_ID);

   SendingPlayerName := MainForm.DXPlay1.LocalPlayer.Name + Slash + IntToStr(MainForm.DXPlay1.LocalPlayer.ID);
   if Assigned(SndToOne) then
   SndToOne(PChar('Action' + '|'+SendingPlayerName+'|'+MsgAction), ReceivingPlayerID);
end;



procedure TfrmPlayerList.PlayMusic1Click(Sender: TObject);
var
i: integer;
PId: integer;
begin

  OpenDialog1.InitialDir := Path + 'gamefiles';
  if OpenDialog1.Execute then
  if playrList.ItemFocused.Caption = 'All Players' then
     SndToOne(PChar('Music' + '|'+ExtractFileName(OpenDialog1.filename)), DPID_ALLPLAYERS)
  else
      begin
           i := playerList.IndexOf(playrList.ItemFocused.Caption);
           if i <> -1 then
           begin
                pId := StrToInt(TVrePlayer(PlayerList.Objects[i]).player_id);
                SndToOne(PChar('Music' + '|'+ExtractFileName(OpenDialog1.filename)),PId);
           end;
      end;
end;

procedure TfrmPlayerList.ShowPicture1Click(Sender: TObject);
var
I: integer;
Pid: Integer;
begin
   OpenPictureDialog1.InitialDir := Path + 'gamefiles';
   if OpenPictureDialog1.execute then
   if frmPlayerList.playrList.ItemFocused.Caption = 'All Players' then
     SndToOne(PChar('Picture' + '|'+ExtractFileName(OpenPictureDialog1.filename)), DPID_ALLPLAYERS)
    else
      begin
         i := playerList.IndexOf(playrList.ItemFocused.Caption);
         if i <> -1 then
         begin
              pId := StrToInt(TVrePlayer(PlayerList.Objects[i]).player_id);
              SndToOne(PChar('Picture' + '|'+ExtractFileName(OpenPictureDialog1.filename)), pId);
         end;
     end;

//frmSndImg.caption := 'Send Image';
//frmSndImg.PageControl1.ActivePage := frmSndImg.TabSheet1;
//frmSndImg.Show;
end;


procedure TfrmPlayerList.PlaySound1Click(Sender: TObject);
var
i: integer;
PId: integer;
begin

// Fix
    OpenDialog2.InitialDir := Path + 'gamefiles';

if OpenDialog2.execute then
if frmPlayerList.playrList.ItemFocused.Caption = 'All Players' then
     SndToOne(PChar('Sound' + '|'+ExtractFileName(OpenDialog2.filename)), DPID_ALLPLAYERS)
  else
      begin
           i := playerList.IndexOf(playrList.ItemFocused.Caption);
           if i <> -1 then
           begin
                pId := StrToInt(TVrePlayer(PlayerList.Objects[i]).player_id);
                SndToOne(PChar('Sound' + '|'+ExtractFileName(OpenDialog2.filename)), pid );
           end;
      end;
{frmSndImg.caption := 'Send Sound';
frmSndImg.PageControl1.ActivePage := frmSndImg.TabSheet2;
frmSndImg.Show;
}
end;

procedure TfrmPlayerList.Timer1Timer(Sender: TObject);
var
i : integer;
begin

    for i := 0 to playrList.Items.Count - 1 do
        begin
             if (playrList.Items.Item[i].ImageIndex = 2) then
                     playrList.Items.Item[i].ImageIndex := 3;

        end;
    timer1.enabled := false;
    timer2.enabled := true;

end;

procedure TfrmPlayerList.playrListDblClick(Sender: TObject);
var
  i: integer;
  MsgWaiting: boolean;
  frmMsg: TfrmDialog;
  frmRcv: TfrmDialog;
begin
MsgWaiting:= false;
if (playrList.selcount = 0) or Not(MainForm.DXplay1.Opened) or (playrList.Items.Count = 1) then exit;

      i := playerList.IndexOf(playrList.ItemFocused.Caption);
      if i <> -1 then
         MsgWaiting := TVrePlayer(frmPlayerList.PlayerList.Objects[i]).message_Waiting;

     if Not(MsgWaiting) then
        begin
             frmMsg := TfrmDialog.Create(Self);
             frmMsg.PageControl1.ActivePage := frmMsg.TabSheet3;
             frmMsg.Caption := 'Private Message for ' + PlayrList.Selected.Caption;

             if frmMsg.ShowModal = mrOk then
             if playrList.ItemFocused.Caption = 'All Players' then
                SendPrivateMessage('DPID_ALLPLAYERS',pMsg)
             else
                SendPrivateMessage(playrList.ItemFocused.Caption,pMsg);

             frmMsg.Free;
             frmMsg := nil;
        end
     else
           begin
              frmRcv := TfrmDialog.Create(Self);
              frmRcv.PageControl1.ActivePage := frmRcv.TabSheet2;
              i := playerList.IndexOf(playrList.ItemFocused.Caption);

              if playrList.ItemFocused.Caption = 'All Players' then
                 frmRcv.label1.caption := 'DPID_ALLPLAYERS'
              else
                  frmRcv.label1.caption := playrList.ItemFocused.Caption;
              if i <> -1 then
              begin
                  frmRcv.mmorcvmsg.text := TVrePlayer(PlayerList.Objects[i]).Player_Messages.Strings[0];
                  TVrePlayer(PlayerList.Objects[i]).Player_Messages.Delete(0);
                  if TVrePlayer(PlayerList.Objects[i]).Player_Messages.Count = 0 then
                     TVrePlayer(PlayerList.Objects[i]).Message_Waiting := false;
              end;

             if frmRcv.ShowModal = mrOk then
             frmRcv.Free;
             frmRcv := nil;
           end;
end;

procedure TfrmPlayerList.Timer2Timer(Sender: TObject);
var
i : integer;
begin

    for i := 0 to playrList.Items.Count - 1 do
        begin
             if (playrList.Items.Item[i].ImageIndex = 3) then
                playrList.Items.Item[i].ImageIndex := 2;


        end;
    timer1.enabled := true;
    timer2.enabled := false;

end;

procedure TfrmPlayerList.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
//if MainForm.DXPlay1.Opened then CanClose := false;
end;

procedure TfrmPlayerList.History1Click(Sender: TObject);
var
MyHistory: TFrmDialog;
i: integer;
begin
     MyHistory := TFrmDialog.Create(self);
     MyHistory.caption := 'Message Log';
     MyHistory.PageControl1.ActivePage := MyHistory.TabSheet1;
     i := playerList.IndexOf(playrList.ItemFocused.Caption);
     if i <> -1 then
        MyHistory.Memo1.Text := TVrePlayer(frmPlayerList.PlayerList.Objects[i]).Chat_History.Text;

     if MyHistory.ShowModal = mrOk then
        begin
             MyHistory.free;
             MyHistory := nil;
        end;

end;

procedure TfrmPlayerList.Blind1Click(Sender: TObject);
var
i: integer;
indxDelete: integer;
plydelete: boolean;
begin
plydelete := false;
indxDelete := playerList.IndexOf(playrList.ItemFocused.Caption);


    if TVrePlayer(frmPlayerList.PlayerList.Objects[indxDelete]).Status_Blind then
       begin//unlock
            frmSysMsg.mmoSysMsg.Lines.Add('Unblinded '+playrList.ItemFocused.caption);
            TVrePlayer(PlayerList.Objects[indxDelete]).Status_Blind := False;
            SendPrivateAction(playrList.ItemFocused.Caption,'NotBlind');
       end
    else
        begin   //Lock
           frmSysMsg.mmoSysMsg.Lines.Add('Blinded '+playrList.ItemFocused.caption);
           TVrePlayer(PlayerList.Objects[indxDelete]).Status_Blind := true;
           SendPrivateAction(playrList.ItemFocused.Caption,'Blind');
        end;

end;

procedure TfrmPlayerList.Def1Click(Sender: TObject);
var
i: integer;
indxDelete: integer;
plydelete: boolean;
begin
plydelete := false;
indxDelete := playerList.IndexOf(playrList.ItemFocused.Caption);

    if TVrePlayer(PlayerList.Objects[indxDelete]).Status_Deaf then
       begin//unlock
            frmSysMsg.mmoSysMsg.Lines.Add('Undeafend '+playrList.ItemFocused.caption);
            TVrePlayer(PlayerList.Objects[indxDelete]).Status_Deaf := false;
            SendPrivateAction(playrList.ItemFocused.Caption,'NotDeaf');
       end
    else
        begin   //Lock
           frmSysMsg.mmoSysMsg.Lines.Add('Deafend '+playrList.ItemFocused.caption);
           TVrePlayer(PlayerList.Objects[indxDelete]).Status_Deaf := true;
           SendPrivateAction(playrList.ItemFocused.Caption,'Deaf');
        end;


end;

procedure TfrmPlayerList.Mute1Click(Sender: TObject);
var
i: integer;
indxDelete: integer;
plydelete: boolean;
begin
plydelete := false;
indxDelete := playerList.IndexOf(playrList.ItemFocused.Caption);


    if TVrePlayer(PlayerList.Objects[indxDelete]).Status_Mute then
       begin//unlock
            frmSysMsg.mmoSysMsg.Lines.Add('Unmuted '+playrList.ItemFocused.caption);
            TVrePlayer(PlayerList.Objects[indxDelete]).Status_Mute := false;
            SendPrivateAction(playrList.ItemFocused.Caption,'NotMute');
       end
    else
        begin   //Lock
           frmSysMsg.mmoSysMsg.Lines.Add('Muted '+playrList.ItemFocused.caption);
           TVrePlayer(PlayerList.Objects[indxDelete]).Status_Mute := true;
           SendPrivateAction(playrList.ItemFocused.Caption,'Mute');
        end;


end;

procedure TfrmPlayerList.tv_eg5DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
   TargetNode : TTreeNode;
   SourceNode : TTreeNode;
begin
/////////////////////////////////////////
// Somthing has just been droped
/////////////////////////////////////////


   with tv_eg5 do
   begin
         {Get the node the item was dropped on}
      TargetNode := GetNodeAt(  X,  Y  );
         {Just to make things a bit easier}
      SourceNode := Selected;


         {Make sure somthing was droped onto}
      if(  TargetNode = nil  ) then
      begin
         EndDrag(  false  );
         Exit;
      end;

         {Dropping onto self or onto parent?}
      if(  (TargetNode = Selected) or
           (TargetNode = Selected.Parent)
        ) then
      begin
         ShowMessage(  'Destination node is the same as the source node'  );
         EndDrag(  false  );
         Exit;
      end;

         {No drag-drop of the root allowed}
      if(  SourceNode.Level = 0  ) then
      begin
         ShowMessage(  'Cant drag/drop the root'  );
         EndDrag(  false  );
         Exit;
      end;


         {Can't drop a parent onto a child}
      if(   IsAParentNode(  Selected,  TargetNode  )   ) then
      begin
         ShowMessage(  'Cant drop parent onto child'  );
         EndDrag(  false  );
         Exit;
      end;

         {Does a node with this name exists as a child of TargetNde}
      if(   IsDuplicateName(  TargetNode.GetFirstChild,  SourceNode.Text,  true  )   ) then
      begin
         ShowMessage(  'A node with this name already exists'  );
         EndDrag(  false  );
         Exit;
      end;

      //////////////////////////////////////////////////////////////
      // Nothing differant up to here.  Just the normal drag and
      //   drop checking.  Now the code to make sure that enforce
      //   "the rules".  Eg books may contain no sub-nodes
      //////////////////////////////////////////////////////////////

         {Use the IsNodeAllowed function to test if the node
           may be dropped here}
      if(  not IsNodeAllowed(   TargetNode,
                                GetNodeType(  SourceNode  )
                              )
         ) then
      begin
         ShowMessage(  'You cant drop this type of node here!'  );
         EndDrag(  false  );
         Exit;
      end;


         {Drag drop was valid so move the nodes}
      MoveTreeNode(  tv_eg5,  SourceNode,  TargetNode  );

         {Delete the old node}
      SourceNode.Delete;


         {Show the nodes that were just moved}
      TargetNode.Expand(  true  );
   end;

end;

procedure TfrmPlayerList.tv_eg5DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
/////////////////////////////////////////
// Decide if drag-drop is to be allowed
/////////////////////////////////////////

   Accept := false;

      {Only accept drag and drop from a TTreeView}
   if(  Sender is TTreeView  ) then
         {Only accept from self}
      if(  TTreeView(Sender) = tv_eg5  ) then
         Accept := true;



end;

function TfrmPlayerList.IsNodeAllowed(  ParentNode : TTreeNode;
                                NewNodesType : eNodeType
                              ) : boolean;
begin
   case GetNodeType(  ParentNode  ) of
      ntRoot :
      begin
            {A root may contain any type of node}
         Result := true;
      end;

      ntFile :
      begin;
            {Files may have no sub-items}
         Result := false;
      end;
   else
         {Unknown node type, dont allow any operations}
      Result := false;
   end;
end;

function TfrmPlayerList.GetNodeType(  Node : TTreeNode  ) : eNodeType;
begin
   if(  Node = nil  ) then
   begin
      Result := ntUnknown;
      Exit;
   end;

      {Determine what type of node this is by looking at the
        node's ImageIndex}
   case Node.ImageIndex of
      IMG_NODE_ROOT : Result := ntRoot;
      IMG_NODE_FILE_CLOSED : Result := ntFile;
   else
         {Node should be one of the above...}
      Result := ntUnknown;
   end;
end;
procedure TfrmPlayerList.AddNode(  NodeType : eNodeType; sText: String  );
begin
         {Add the node}
      with tv_eg5.Items.AddChild( tv_eg5.Items.Item[0],  sText  ) do
      begin
         case NodeType of
            ntFile :
            begin
                  {Set the image used when the node is not selected}
               ImageIndex := IMG_NODE_FILE_CLOSED;
                  {Image used when the node is selected}
               SelectedIndex := IMG_NODE_FILE_OPEN;
               MakeVisible;
            end;
         else
               {Trying to add a node that is not a file or a folder,
                 this is not allowed. So remove the node that was
                 just created.}
            Delete;
         end;
      end;

end;

procedure TfrmPlayerList.Button1Click(Sender: TObject);
var
i : integer;
begin
     for i := 0 to tv_eg5.Items.Count - 1 do
         begin
           if GetNodeType(tv_eg5.Items.Item[i]) = ntFile then
              SendPrivateAction(tv_eg5.Items.Item[i].text,tv_eg5.Items.Item[i].Parent.Text);

           if GetNodeType(tv_eg5.Items.Item[i]) = ntRoot then
              begin
                   if (tv_eg5.Items.Item[i].text = 'Group 1') then
                      if (tv_eg5.Items.Item[i].HasChildren) then
                         begin
                              frmChat.cbGroup1.enabled := true;
                              frmChat.cbGroup1.Checked := true;
                         end
                      else
                          begin
                               frmChat.cbGroup1.enabled := false;
                               frmChat.cbGroup1.Checked := false;
                          end;

                   if (tv_eg5.Items.Item[i].text = 'Group 2') then
                      if (tv_eg5.Items.Item[i].HasChildren) then
                         begin
                              frmChat.cbGroup2.enabled := true;
                              frmChat.cbGroup2.Checked := true;
                         end
                      else
                          begin
                               frmChat.cbGroup2.enabled := false;
                               frmChat.cbGroup2.Checked := false;
                          end;
                   if (tv_eg5.Items.Item[i].text = 'Group 3') then
                      if (tv_eg5.Items.Item[i].HasChildren) then
                         begin
                              frmChat.cbGroup3.enabled := true;
                              frmChat.cbGroup3.Checked := true;
                         end
                      else
                          begin
                               frmChat.cbGroup3.enabled := false;
                               frmChat.cbGroup3.Checked := false;
                          end;
                   if (tv_eg5.Items.Item[i].text = 'Group 4') then
                      if (tv_eg5.Items.Item[i].HasChildren) then
                         begin
                              frmChat.cbGroup4.enabled := true;
                              frmChat.cbGroup4.Checked := true;
                         end
                      else
                          begin
                               frmChat.cbGroup4.enabled := false;
                               frmChat.cbGroup4.Checked := false;
                          end;
              end;


         end;
end;

procedure TfrmPlayerList.FormDestroy(Sender: TObject);
begin
    while PlayerList.count <> 0 do
    begin
          TVrePlayer(PlayerList.Objects[0]).ReIndex;
          TVrePlayer(PlayerList.Objects[0]).free;
    end;
    PlayerList.Clear;
    PlayerList.Free;
    PlayerList := nil;

end;

procedure TfrmPlayerList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
MainForm.PlayerList1.checked := false;
end;

procedure TfrmPlayerList.FormCreate(Sender: TObject);
begin
PlayerList:= TStringList.Create;
end;

initialization
t:= true;

end.

