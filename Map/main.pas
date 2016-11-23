unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, StdCtrls,ImageManager, VRSprite, strFunctions, ComCtrls,
  ExtDlgs, Wordcap, TreeNT;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    Grid1: TMenuItem;
    Hex1: TMenuItem;
    Square1: TMenuItem;
    Color1: TMenuItem;
    Background1: TMenuItem;
    Grid2: TMenuItem;
    ColorDialog: TColorDialog;
    sbMain: TScrollBox;
    iMap: TImage;
    Panel1: TPanel;
    Splitter1: TSplitter;
    File1: TMenuItem;
    Exit1: TMenuItem;
    ClearGrid1: TMenuItem;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    N1: TMenuItem;
    N2: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    None1: TMenuItem;
    Background2: TMenuItem;
    LoadanImage1: TMenuItem;
    Stretched1: TMenuItem;
    Tiled1: TMenuItem;
    Centered1: TMenuItem;
    N3: TMenuItem;
    OpenPictureDialog: TOpenPictureDialog;
    ClearImage1: TMenuItem;
    TopLeft1: TMenuItem;
    Panel2: TPanel;
    Splitter2: TSplitter;
    imgPreview: TImage;
    MSOfficeCaption1: TMSOfficeCaption;
    tvImage: TTreeNT;
    procedure Exit1Click(Sender: TObject);
    procedure Background1Click(Sender: TObject);
    procedure Grid2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Hex1Click(Sender: TObject);
    procedure DrawOctagon(var bmp: TBitmap);
    procedure DrawSquare(var bmp: TBitmap);
    procedure Square1Click(Sender: TObject);
    procedure iMapMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure iMapMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure RefreshGrid;
    procedure LoadSprites(var Bmp: TBitmap);
    procedure iMapMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LoadTreeData;
    procedure tvImageClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tvImageDblClick(Sender: TObject);
    procedure ClearGrid1Click(Sender: TObject);
    procedure SaveToFile;
    procedure LoadFromFile;
    procedure Save1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure None1Click(Sender: TObject);
    procedure LoadanImage1Click(Sender: TObject);
    procedure ClearImage1Click(Sender: TObject);
    procedure TopLeft1Click(Sender: TObject);
    procedure Centered1Click(Sender: TObject);
    procedure Stretched1Click(Sender: TObject);
    procedure Tiled1Click(Sender: TObject);

  private
    { Private declarations }
       BmpBuffer: TBitmap;
       BackBuffer: TBitmap;
       MouseImage: TBitmap;
       MainImgMngr: TImageManager;
       DragImage: Boolean;
       FloaterSprite: TBaseSprite;
       ImageFileName: string;
       AddMode: boolean;
       MouseX: integer;
       MouseY: integer;

  public
    { Public declarations }
      bgColor,gColor: TColor;
      SpriteList: TList;
      BGSprite: TBackGroundSprite;
      Background: TBitmap;

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
     close;
end;

procedure TfrmMain.Background1Click(Sender: TObject);
begin
//Changed the background color
if ColorDialog.execute then
   bgColor := ColorDialog.Color;

   RefreshGrid;

end;

procedure TfrmMain.Grid2Click(Sender: TObject);
begin
//changed the Grid Color
if ColorDialog.execute then
   gColor := ColorDialog.Color;

   RefreshGrid;

end;


procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    try
      BmpBuffer.FreeImage;
      BmpBuffer.ReleaseHandle;
      BmpBuffer.free;
      BmpBuffer := nil;

      BackBuffer.FreeImage;
      BackBuffer.ReleaseHandle;
      BackBuffer.free;
      BackBuffer := nil;

      if Assigned(BackGround) then
         BackGround.free;

      if Assigned(BGSprite) then
         BGSprite.free;

      MainImgMngr.free;
      SpriteList.clear;
      SpriteList.free;
    except
    end;
end;

procedure TfrmMain.Hex1Click(Sender: TObject);
begin
     //switch to Octagons
     hex1.checked := true;
     Square1.checked := false;
     None1.Checked := false;

     RefreshGrid;

end;

procedure TfrmMain.Square1Click(Sender: TObject);
begin
     //switch to Squares
     hex1.checked := false;
     Square1.checked := true;
     None1.Checked := false;

     RefreshGrid;

end;

procedure TfrmMain.DrawSquare(var bmp: TBitmap);
var
x,y: Integer;
iLoop: integer;
begin
// Draw the Square Grid
Bmp.Canvas.Pen.Color := gColor;

          x := 0;
          for iLoop := 0 to Bmp.width div 48 do
          begin
               //Verticle
               X := X + 48;
               Bmp.Canvas.Moveto(x, 0);

               Bmp.Canvas.LineTo(x,iMap.Height);
          end;

          y := 0;
          for iLoop := 0 to iMap.width div 48 do
          begin
               //horizontal
               y := y + 48;
               Bmp.Canvas.Moveto(0, y);

               Bmp.Canvas.LineTo(iMap.width,y);
          end;


end;

procedure TfrmMain.DrawOctagon(Var bmp: TBitmap);
var
x,y: Integer;
x1,y1: Integer;
mLoop: integer;
iLoop: integer;
begin
//  32X28  X 14
// Draw the Hex grid
X1 := 1;
Y1 := 29;
Bmp.Canvas.Pen.Color := gColor;

      for mLoop := 0 to Bmp.height div 56 do
      begin
          X := x1;
          Y := y1;
          Bmp.Canvas.Moveto(x, y);
          //Top
          for iLoop := 0 to Bmp.width div 32 do
          begin
               //Up
               X := X + 15;
               y := y - 28;
               Bmp.Canvas.LineTo(x,y);
               //over
               X := X + 32;
               Bmp.Canvas.LineTo(x,y);
               //down
               X := X + 15;
               y := y + 28;
               Bmp.Canvas.LineTo(x,y);
               //over
               X := X + 32;
               Bmp.Canvas.LineTo(x,y);
          end;

          X := x1;
          Y := y1;
          Bmp.Canvas.Moveto(x, y);
          //Bottom
          for iLoop := 0 to iMap.width div 32 do
          begin
               //down
               X := X + 15;
               y := y + 28;
               Bmp.Canvas.LineTo(x,y);
               //over
               X := X + 32;
               Bmp.Canvas.LineTo(x,y);
               //Up
               X := X + 15;
               y := y - 28;
               Bmp.Canvas.LineTo(x,y);
               //over
               X := X + 32;
               Bmp.Canvas.LineTo(x,y);
          end;
           y1 := y1 + 56;
      end;


end;


procedure TfrmMain.iMapMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
      if Not(Assigned(MouseImage)) then exit;

      //Draw the current image attached to the mouse
      BmpBuffer.Canvas.Draw(0,0,BackBuffer);
      BmpBuffer.Canvas.Draw(x-(MouseImage.width div 2),y-MouseImage.Height,MouseImage);

      iMap.canvas.Draw(0,0,BmPBuffer);

end;

procedure TfrmMain.iMapMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var
  MySprite: TBaseSprite;
  iLoop: integer;
  itmp: integer;

begin
     //Delete a selected Image
     if (Button = mbRight) and (ssShift in Shift) then
     begin
        for iLoop := 0 to spriteList.count -1 do
        begin
            MySprite := SpriteList.items[iLoop];
            if (X > MySprite.x) and (X < (MySprite.x + MySprite.width))  then
            if (y > MySprite.y) and (y < (MySprite.y + MySprite.Height))  then
            begin
                 SpriteList.delete(iLoop);
                 SpriteList.Capacity := SpriteList.count;
                 Break;
            end;
        end;
        RefreshGrid;
        Exit;
     end;

     itmp := -1;
     //Check for an Image to move
     if Not(assigned(MouseImage)) and (ssLeft in Shift ) then
     begin
        for iLoop := 0 to spriteList.count -1 do
        begin
            MySprite := SpriteList.items[iLoop];
            if (X > MySprite.x) and (X < (MySprite.x + MySprite.width))  then
            if (y > MySprite.y) and (y < (MySprite.y + MySprite.Height))  then
            begin
               FloaterSprite := SpriteList.items[iLoop];
               itmp:= iLoop;
            end;

            MySprite := nil;
        end;
        //Nothin to move
        if Not(Assigned(FloaterSprite)) then exit;

        //Set up for the move
        MouseX:= X;
        MouseY:=Y;
        DragImage := true;
        MouseImage := TBitmap.Create;
        MouseImage.TransparentMode := tmAuto;
        MouseImage.Transparent := true;
        MouseImage.LoadFromFile(FloaterSprite.filename);
        MouseImage.Dormant;

        SpriteList.delete(iTmp);
        SpriteList.Capacity := SpriteList.count;

        RefreshGrid;

        exit;
     end;

     //Cancle drawing
     if Button = mbRight then
     begin
          AddMode := false;
          if Assigned(MouseImage) then
          begin
               MouseImage.ReleaseHandle;
               MouseImage.FreeImage;
               MouseImage.free;
               MouseImage := nil;
          end;
          RefreshGrid;
     end;
     //Place the image in the current spot
     if Button = mbLeft then
     begin
          MainImgMngr.AddImage2(MouseImage);

          MySprite := TBaseSprite.Create(self);
          MySprite.ImageName := StrTokenAt(extractFileName(ImageFileName),'.',0);
          MySprite.GUID := StrTokenAt(extractFileName(ImageFileName),'.',0) + IntTostr(x) + IntTostr(y);
          MySprite.ImageIndex := MainImgMngr.ImageCount - 1;
          MySprite.x := x-(MouseImage.width div 2);
          MySprite.y := y-MouseImage.Height;
          MySprite.Height := MouseImage.Height;
          MySprite.width := MouseImage.Width;
          MySprite.FileName := ImageFileName;


          Spritelist.Add(MySprite);

          MySprite := Nil;
          if Not(Addmode) then
          begin
               MouseImage.ReleaseHandle;
               MouseImage.FreeImage;
               MouseImage.free;
               MouseImage := nil;
          end;

          RefreshGrid;
     end;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
   //Buffer to preven flicker
   BmpBuffer := TBitmap.Create;
   BmpBuffer.Height := 618;
   BmpBuffer.Width := 815;
   BmpBuffer.canvas.TextFlags := ETO_OPAQUE;
   // To cut down on redraws for mouse moves
   BackBuffer := TBitmap.Create;
   BackBuffer.Height := 618;
   BackBuffer.Width := 815;
   BackBuffer.canvas.TextFlags := ETO_OPAQUE;

   //will hold all images
   MainImgMngr := TImageManager.Create;
   MainImgMngr.MaxImageCache := 32;

   //List of Currently drawn images
   SpriteList := TList.Create;

   //default Setting
   bgColor := clWhite;
   gColor := clSilver;
   DragImage:= false;
   RefreshGrid; //Draw the first grid



end;

procedure TfrmMain.RefreshGrid;
begin
   //  imap.Picture := nil;
     //Clear the buffer
     BmpBuffer.Canvas.Brush.Color := bgColor;
     BmpBuffer.Canvas.FillRect(Rect(0,0,815,618));

     if Assigned(BackGround) then
        BmpBuffer.Canvas.Draw(BGSprite.x,BGSprite.y,BackGround);

     if Hex1.checked then
        DrawOctagon(BmpBuffer);

     if Square1.checked then
        DrawSquare(BmpBuffer);

     //Draw all loaded Sprites
     LoadSprites(BmpBuffer);

     //Flip the buffer
     iMap.canvas.Draw(0,0,BmPBuffer);
     //Make a backup
 //    BmpBuffer.Dormant;

     BackBuffer.Canvas.Draw(0,0,BmPBuffer);
//     BackBuffer.Dormant;
end;

procedure TfrmMain.LoadSprites(var Bmp: TBitmap);
var
iLoop: integer;
MySprite: TBaseSprite;
begin

    if SpriteList.Count = 0 then exit;
   // Loop throught he sprite lists looking for sprites to draw
    for iloop := 0 to SpriteList.Count -1 do
    begin
      MySprite := SpriteList.Items[iLoop];
      if MySprite.Visible then
      begin
         MainImgMngr.DrawImage(MySprite.ImageIndex, bmp.canvas, MySprite.x,MySprite.y);
         //The sprite Caption
         //if MySprite.ShowCaption then
         //   Bmp.Canvas.TextOut(MySprite.x,MySprite.y+MySprite.height,mySprite.ImageName);
      end;
      MySprite := nil;
    end;
end;

procedure TfrmMain.iMapMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     //if we are dragging an image then place it
     if DragImage and Assigned(FloaterSprite) then
     begin
          DragImage :=  false;

          if (MouseX <> X) and (MouseY <> Y) then
          begin
               FloaterSprite.x := x-(FloaterSprite.width div 2);
               FloaterSprite.y := y-FloaterSprite.Height;
          end;
          MouseX := -1;
          MouseY:=-1;
          Spritelist.Add(FloaterSprite);

          FloaterSprite := nil;

          MouseImage.ReleaseHandle;
          MouseImage.FreeImage;
          MouseImage.free;
          MouseImage := nil;

          RefreshGrid;
     end;
end;


procedure TfrmMain.LoadTreeData;
var
strLine: string;
iLoop: integer;
nLoop: integer;
treeFile: TextFile;
RootFlag: TTreeNTNode;
tmpNode: TTreeNTNode;
NodeExists: Boolean;
begin
   //Load the tree view with images -- TTree View SUCKS!!
   AssignFile(TreeFile, extractfilepath(application.exename)+ 'tree.dat');                                     // Get our handle
   ReSet(TreeFile);

   while Not(Eof(Treefile)) do
   begin
        Readln(TreeFile,strLine);
        strLine := Trim(StrLine);

        if (LowerCase(StrLine) <> 'endroot') and (strLine <> '')then
        begin

             tmpNode := nil;
             if LowerCase(strTokenAt(StrLine, '\', 0)) = 'root' then
             begin
                   RootFlag := tvImage.Items.add(nil,strTokenAt(StrLine, '\', 1));
             end
             else
             begin
                  if FileExists(ExtractFilePath(Application.exeName) + 'Resources\Map\' +strTokenAt(StrLine, '\', strTokenCount(strLine,'\')-1)) then
                  begin
                      tmpNode := RootFlag;
                      for iLoop := 0 to StrTokenCount(StrLine,'\') -1 do
                      begin
                           if tmpNode.HasChildren then
                           begin
                              //search through the children
                             NodeExists := false;
                             for nLoop:= 0 to tmpNode.Count -1 do
                             begin
                                 if tmpNode.Item[nLoop].text = StrTokenAt(StrLine,'\',iLoop) then
                                 begin
                                    TmpNode := tmpNode.Item[nLoop];
                                    NodeExists:= true;
                                    Break;
                                 end;
                             end;
                             if Not(NodeExists) then
                             begin
                                 tmpNode :=  tvImage.Items.AddChild(tmpNode,strTokenAt(StrLine, '\', iLoop));
                             end;
                           end
                           else
                              tmpNode :=  tvImage.Items.AddChild(tmpNode,strTokenAt(StrLine, '\', iLoop));
                      end;
                  end;
             end;
        end;
   end;

   CloseFile(TreeFile);


end;

procedure TfrmMain.tvImageClick(Sender: TObject);
begin
     //choose an image to draw
     if tvImage.Selected = nil then exit;
     if (LowerCase(strRight(tvImage.Selected.text,4)) = '.bmp') then
        ImageFileName := ExtractFilePath(Application.exeName) + 'Resources\Map\' + tvImage.Selected.text;

     if fileExists(ImageFileName) then
     begin
          if Not(Assigned(MouseImage)) then
          begin
               MouseImage := TBitmap.Create;
               MouseImage.TransparentMode := tmAuto;
               MouseImage.Transparent := true;
          end;
          MouseImage.LoadFromFile(ImageFileName);
          MouseImage.Dormant;

          ImgPreview.Picture := nil;
          ImgPreview.Canvas.Brush.Color := clBlack;
          ImgPreview.Canvas.FillRect(Rect(0,0,ImgPreview.width,ImgPreview.height));

          ImgPreview.Canvas.Draw(0,0,MouseImage);
     end;

end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
     LoadTreeData;
end;

procedure TfrmMain.tvImageDblClick(Sender: TObject);
begin
   //switch to draw mode
   AddMode:= true;
end;

procedure TfrmMain.ClearGrid1Click(Sender: TObject);
begin
  //confirm clear
  if MessageDlg('Are you shure you want to clear the entire map?',mtConfirmation,[mbYes, mbNo],0) = mryes then
  SpriteList.Clear;

  RefreshGrid;

end;

procedure TfrmMain.SaveToFile;
var
   iLoop: Integer;
   Output: TextFile;
begin



     if SaveDialog.execute then
     begin
         if FileExists(SaveDialog.filename) then
            deletefile(SaveDialog.filename);
         AssignFile(Output, SaveDialog.fileName);
         ReWrite(Output);
         Append(Output);

         if Assigned(BGSprite) then
         begin
             Writeln(Output,ExtractFileName(BGSprite.FileName));
             if BGSprite.Centered then
                Writeln(Output,'true')
             else
                Writeln(Output,'false');
             if BGSprite.Tiled then
                Writeln(Output,'true')
             else
                Writeln(Output,'false');
             if BGSprite.TopLeft then
                Writeln(Output,'true')
             else
                Writeln(Output,'false');
             if BGSprite.Stretched then
                Writeln(Output,'true')
             else
                Writeln(Output,'false');

             Writeln(Output,'');
         end
         else
             for iLoop := 0 to 5 do
                 Writeln(Output,'');

         for iLoop := 0 to SpriteList.count -1 do
         begin
              Writeln(Output,ExtractFileName(TBaseSprite(SpriteList.items[iLoop]).FileName));
              Writeln(Output,IntToStr(TBaseSprite(SpriteList.items[iLoop]).X));
              Writeln(Output,IntToStr(TBaseSprite(SpriteList.items[iLoop]).Y));
              if TBaseSprite(SpriteList.items[iLoop]).Visible then
                 Writeln(Output,'true')
              else
                 Writeln(Output,'false');
              if TBaseSprite(SpriteList.items[iLoop]).ShowCaption then
                 Writeln(Output,'true')
              else
                 Writeln(Output,'false');

                 Writeln(Output,'');
         end;

         CloseFile(Output);

     end;
end;

procedure TfrmMain.LoadFromFile;
var
   Output: TextFile;
   Msg: string;
   strFileName: String;
   iX: integer;
   iY: integer;
   bVisible: Boolean;
   bShowCaption: Boolean;
   bCentered: boolean;
   bTiled: Boolean;
   bTopLeft: Boolean;
   bStretched: Boolean;
   iLoop: integer;
   MySprite: TBaseSprite;
   tmpImage: TBitmap;
begin
     OpenDialog.InitialDir := ExtractFilePath(Application.exeName);;
     if OpenDialog.execute then
     begin
         SpriteList.Clear;
         AssignFile(Output, OpenDialog.fileName);
         ReSet(Output);

         Readln(Output,strFileName);

         Readln(Output,msg);
         if LowerCase(msg) = 'true' then
            bCentered := true
         else
             bCentered := false;

         Readln(Output,msg);
         if LowerCase(msg) = 'true' then
            bTiled := true
         else
             bTiled := false;

         Readln(Output,msg);
         if LowerCase(msg) = 'true' then
            bTopLeft := true
         else
             bTopLeft := false;

         Readln(Output,msg);
         if LowerCase(msg) = 'true' then
            bStretched := true
         else
            bStretched := false;

          Readln(Output,msg);

         if Trim(StrFileName) <> '' then
         if FileExists(ExtractFilePath(Application.exeName) + 'Resources\Map\' + strFileName) then
         begin
              tmpImage := TBitmap.create;
              tmpImage.loadfromFile(ExtractFilePath(Application.exeName) + 'Resources\Map\' + strFileName);
              tmpImage.Dormant;

              if Assigned(BackGround) then
              begin
                   Background.FreeImage;
                   Background.ReleaseHandle;
                   BackGround := nil;
                   BackGround.free;
                   BGSprite.free;
                   BGSprite := nil;
              end;

              BackGround := TBitmap.Create;

              BGSprite:= TBackgroundSprite.create(self);
              BGSprite.ImageName := StrTokenAt(strFileName,'.',0);
              BGSprite.GUID := StrTokenAt(strFileName,'.',0);
              BGSprite.ImageIndex := MainImgMngr.ImageCount - 1;
              BGSprite.x := 0;
              BGSprite.y := 0;
              BGSprite.Height := tmpImage.Height;
              BGSprite.width := tmpImage.Width;
              BGSprite.FileName := ExtractFilePath(Application.exeName) + 'Resources\Map\' + strFileName;
              BGSprite.image := tmpImage;
              BGSprite.Centered := bCentered;
              BGSprite.Tiled := bTiled;
              BGSprite.TopLeft := bTopLeft;
              BGSprite.Stretched := bStretched;

              tmpImage.FreeImage;
              tmpImage.ReleaseHandle;
              tmpImage.free;
              tmpImage := nil;
         end
         else
             for iLoop := 0 to 5 do
                 Readln(Output,msg);



         while Not(Eof(OutPut)) do
         begin

              Readln(Output,strFileName);

              Readln(Output,msg);
              iX := StrToInt(msg);

              Readln(Output,msg);
              iY := StrToInt(msg);

              Readln(Output,msg);
              if LowerCase(msg) = 'true' then
                 bVisible := true
              else
                  bVisible := false;

              Readln(Output,msg);
              if LowerCase(msg) = 'true' then
                 bShowCaption := true
              else
                  bShowCaption := false;

              Readln(Output,msg);

              if FileExists(ExtractFilePath(Application.exeName) + 'Resources\Map\' + strFileName) then
              begin
                  tmpImage := TBitmap.create;
                  tmpImage.TransparentMode := tmAuto;
                  tmpImage.Transparent := true;
                  tmpImage.loadfromFile(ExtractFilePath(Application.exeName) + 'Resources\Map\' + strFileName);
                  tmpImage.Dormant;

                  MainImgMngr.AddImage2(tmpImage);

                  MySprite := TBaseSprite.Create(self);
                  MySprite.ImageName := StrTokenAt(strFileName,'.',0);
                  MySprite.GUID := StrTokenAt(strFileName,'.',0) + IntTostr(iX) + IntTostr(iY);
                  MySprite.ImageIndex := MainImgMngr.ImageCount - 1;
                  MySprite.x := iX;
                  MySprite.y := iY;
                  MySprite.Height := tmpImage.Height;
                  MySprite.width := tmpImage.Width;
                  MySprite.FileName := ExtractFilePath(Application.exeName) + 'Resources\Map\' + strFileName;
                  MySprite.Visible := bVisible;
                  MySprite.ShowCaption := bShowCaption;

                  Spritelist.Add(MySprite);

                  MySprite := Nil;

                  tmpImage.ReleaseHandle;
                  tmpImage.FreeImage;

                  tmpImage.free;
                  tmpImage := nil;
              end;
         end;

         CloseFile(Output);

         if Assigned(BackGround) then
         begin
              TopLeft1.enabled := true;
              Centered1.enabled := true;
              Stretched1.enabled := true;
              Tiled1.enabled := true;

              if bCentered then Centered1Click(self);
              if bTiled then Tiled1Click(self);
              if bTopLeft then TopLeft1Click(self);
              if bStretched then Stretched1Click(self);
         end;

//         Refreshgrid;

     end;
end;


procedure TfrmMain.Save1Click(Sender: TObject);
begin
    SaveToFile;
end;

procedure TfrmMain.Open1Click(Sender: TObject);
begin
     LoadFromFile;
     RefreshGrid;
end;

procedure TfrmMain.None1Click(Sender: TObject);
begin
     None1.Checked := true;
     Hex1.checked := false;
     Square1.checked := false;

     RefreshGrid;

end;

procedure TfrmMain.LoadanImage1Click(Sender: TObject);
begin
   OpenPictureDialog.InitialDir := ExtractFilePath(Application.exeName);
   if OpenPictureDialog.execute then
   begin
        if Assigned(BackGround) then
        begin
             Background.FreeImage;
             Background.ReleaseHandle;
             BackGround := nil;
             BackGround.free;
             BGSprite.free;
             BGSprite := nil;
        end;
        BGSprite:= TBackgroundSprite.create(self);

        BackGround := TBitmap.Create;
        BackGround.LoadFromFile(OpenPictureDialog.fileName);
        //BackGround.Dormant;

        BGSprite.ImageName := StrTokenAt(OpenPictureDialog.fileName,'.',0);
        BGSprite.GUID := StrTokenAt(OpenPictureDialog.fileName,'.',0);
        BGSprite.ImageIndex := -1;
        BGSprite.x := 0;
        BGSprite.y := 0;
        BGSprite.Height := BackGround.Height;
        BGSprite.width := BackGround.Width;
        BGSprite.FileName := ExtractFileName(OpenPictureDialog.fileName);
        BGSprite.image := BackGround;

        TopLeft1.checked := true;
        Centered1.checked := false;
        Stretched1.checked := false;
        Tiled1.checked := false;

        TopLeft1.enabled := true;
        Centered1.enabled := true;
        Stretched1.enabled := true;
        Tiled1.enabled := true;

        Refreshgrid;
   end;


end;

procedure TfrmMain.ClearImage1Click(Sender: TObject);
begin
     if Assigned(BackGround) then
     begin
         Background.FreeImage;
         Background.ReleaseHandle;
         BackGround := nil;
         BGSprite.free;
         BGSprite := nil;
         RefreshGrid;
         TopLeft1.enabled := false;
         Centered1.enabled := false;
         Stretched1.enabled := false;
         Tiled1.enabled := false;
     end;
end;

procedure TfrmMain.TopLeft1Click(Sender: TObject);
begin
    TopLeft1.checked := true;
    Centered1.checked := false;
    Stretched1.checked := false;
    Tiled1.checked := false;
    BGSprite.Centered := false;
    BGSprite.TopLeft := true;
    BGSprite.Stretched := false;
    BGSprite.Tiled := false;
    BgSprite.x := 0;
    BgSprite.y := 0;

    BackGround.Height := BgSprite.image.height;
    BackGround.width := BgSprite.image.width;

    BackGround.Canvas.Draw(0,0,BgSprite.image);
    //BackGround.Dormant;

    RefreshGrid;

end;

procedure TfrmMain.Centered1Click(Sender: TObject);
begin
    TopLeft1.checked := false;
    Centered1.checked := true;
    Stretched1.checked := false;
    Tiled1.checked := false;
    BGSprite.Centered := true;
    BGSprite.TopLeft := false;
    BGSprite.Stretched := false;
    BGSprite.Tiled := false;

    BGSprite.x := (BmpBuffer.width div 2) - (BGSprite.image.Width div 2);
    BGSprite.y := (BmpBuffer.Height Div 2) - (BGSprite.Image.height div 2);

    RefreshGrid;

end;

procedure TfrmMain.Stretched1Click(Sender: TObject);
begin
    TopLeft1.checked := false;
    Centered1.checked := false;
    Stretched1.checked := true;
    Tiled1.checked := false;
    BGSprite.Centered := false;
    BGSprite.TopLeft := false;
    BGSprite.Stretched := True;
    BGSprite.Tiled := false;
    BgSprite.x := 0;
    BgSprite.y := 0;

    BackGround.Height := BmpBuffer.height;
    BackGround.width := bmpBuffer.width;

    BackGround.Canvas.StretchDraw(Rect(0,0,Background.width,Background.height), BgSprite.image);
   // Background.Dormant;

    RefreshGrid;

end;

procedure TfrmMain.Tiled1Click(Sender: TObject);
var
iLoop : integer;
mLoop : integer;
begin
    TopLeft1.checked := false;
    Centered1.checked := false;
    Stretched1.checked := false;
    Tiled1.checked := true;
    BGSprite.Centered := false;
    BGSprite.TopLeft := false;
    BGSprite.Stretched := false;
    BGSprite.Tiled := true;
    BgSprite.x := 0;
    BgSprite.y := 0;

    BackGround.Height := BmpBuffer.height;
    BackGround.width := bmpBuffer.width;

    for iLoop := 0 to (BackGround.width div BGSprite.image.width) do
       for mLoop := 0 to (BackGround.height div BGSprite.image.height) do
           BackGround.Canvas.Draw(BGSprite.image.width * iLoop,BGSprite.image.height * mLoop,BgSprite.image);
  //  BackGround.Dormant;
    RefreshGrid;
end;



end.
