unit TV_FolderFile_U1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls,  ActiveX,  TreeUtils,  TDocFile_U1, ImgList;

const
   IMG_NODE_ROOT = 0;
   IMG_NODE_FILE_CLOSED = 1;
   IMG_NODE_FILE_OPEN = 2;
   IMG_NODE_FOLDER_CLOSED = 3;
   IMG_NODE_FOLDER_OPEN = 4;


type
      {Enum used for easily identifying nodes}
   eNodeType = (ntUnknown,  ntRoot,  ntFile,  ntFolder);

  TForm1 = class(TForm)
    tv_eg5: TTreeView;
    but_AddFolder: TButton;
    but_Remove: TButton;
    ImageList1: TImageList;
    but_AddFile: TButton;
    but_Save: TButton;
    but_Load: TButton;
    procedure but_RemoveClick(Sender: TObject);
    procedure but_AddFolderClick(Sender: TObject);
    procedure but_AddFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure but_SaveClick(Sender: TObject);
    procedure but_LoadClick(Sender: TObject);
  private
     function GetNodeType(  Node : TTreeNode  ) : eNodeType;
     procedure AddRootNode;
     procedure AddNode(  NodeType : eNodeType  );

     function IsNodeAllowed(  ParentNode : TTreeNode;
                              NewNodesType : eNodeType
                            ) : boolean;

     function LoadName_callback(  sElementName : WideString;
                                  dwType : DWORD;
                                  pData : pointer
                                ) : boolean;

  public
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


procedure TForm1.FormCreate(Sender: TObject);
begin
      {Add the root node}
   AddRootNode;
end;



//////////////////////////////////////////////////////////////
// Returns one of the eNodeType values to indicate what type
//  of node param 1 is.
//////////////////////////////////////////////////////////////
function TForm1.GetNodeType(  Node : TTreeNode  ) : eNodeType;
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
      IMG_NODE_FOLDER_CLOSED : Result := ntFolder;
   else
         {Node should be one of the above...}
      Result := ntUnknown;
   end;
end;



///////////////////////////////////////////////////////
// Check if a new node of type NewNodeType may be
//   created as a child off ParentNode
///////////////////////////////////////////////////////
function TForm1.IsNodeAllowed(  ParentNode : TTreeNode;
                                NewNodesType : eNodeType
                              ) : boolean;
begin
   case GetNodeType(  ParentNode  ) of
      ntRoot :
      begin
            {A root may contain any type of node}
         Result := true;
      end;

      ntFolder :
      begin
            {Folder may contain any type of node}
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



///////////////////////////////////////////////////
// Procedure used to add a file / folder node
///////////////////////////////////////////////////
procedure TForm1.AddNode(  NodeType : eNodeType  );
var
   sText : string;
begin
      {If nothing is selected}
   if(  tv_eg5.Selected = nil  ) then
   begin
         {There is a root, so user must first select a node}
      MessageBeep(  -1  );
      ShowMessage(  'Select parent node'  );
      Exit;
   end
   else begin
         {Get a name for the new node}
      if(   not InputQuery(  'New Node',  'Caption ?',  sText  )   ) then
         Exit;

         {Check if this name is already in use}
      if(   IsDuplicateName(  tv_eg5.Selected.GetFirstChild,
                              sText,
                              true
                            )
         ) then
      begin
         MessageBeep(  -1  );
         ShowMessage(  'A node with this name already exists'  );
         Exit;
      end;

         {Check if adding this type of node is allowed}
      if(   not IsNodeAllowed(  tv_eg5.Selected,  NodeType  )   ) then
      begin
         MessageBeep(  -1  );
         ShowMessage(  'Cant creat this type of node here'  );
         Exit;
      end;

         {Add the node}
      with tv_eg5.Items.AddChildFirst(  tv_eg5.Selected,  sText  ) do
      begin
         case NodeType of
            ntFolder :
            begin
                  {Set the image used when the node is not selected}
               ImageIndex := IMG_NODE_FOLDER_CLOSED;
                  {Image used when the node is selected}
               SelectedIndex := IMG_NODE_FOLDER_OPEN;
               MakeVisible;
            end;

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
end;



///////////////////////////////////
// Adds the root to an empty tree
///////////////////////////////////
procedure TForm1.AddRootNode;
begin
      {If the tree is empty}
   if(  tv_eg5.Items.Count = 0  ) then
   begin
         {Add the root node}
      with tv_eg5.Items.AddFirst(  nil,  'Root'  ) do
      begin
         Selected := true;

            {Set the roots image index}
         ImageIndex := IMG_NODE_ROOT;
            {Set the roots selected index. The same image is uses
               as for the ImageIndex}
         SelectedIndex := IMG_NODE_ROOT;
      end;
   end
end;



//////////////////////////////////////////////////
// User wants to remove the selected item
//////////////////////////////////////////////////
procedure TForm1.but_RemoveClick(Sender: TObject);
begin
      {Make sure somthing is selected, before trying to
        delete it}
   if(  tv_eg5.Selected = nil  ) then
   begin
      MessageBeep(  -1  );
      ShowMessage(  'Nothing selected'  );
      Exit;
   end;

      {Dont allow user to delete the root node}
   if(  tv_eg5.Selected.Level = 0  ) then
   begin
      MessageBeep(  -1  );
      ShowMessage(  'Cant delete the root node'  );
      Exit;
   end;

      {Delete the node}
   tv_eg5.Selected.Delete;
end;



procedure TForm1.but_AddFolderClick(Sender: TObject);
begin
   AddNode(  ntFolder  );
end;



procedure TForm1.but_AddFileClick(Sender: TObject);
begin
   AddNode(  ntFile  );
end;



procedure Save_CallBack(  Node : TTreeNode;  pData : pointer  );
var
   stor : TDocFileStorage;
   subStor : TDocFileStorage;
   strmImages : TDocFileStream;
begin
      {End of recursion (base case)}
   if(  (Node = nil) or (pData = nil)  ) then
      Exit;

   stor := TDocFileStorage(pData);

      {Create a storage for this node
        NB Remeber the limits on a storage element's name,
        (31 chars max etc...)}
   subStor := stor.CreateStorage(  Node.Text,  MY_STGM_CREATE  );

      {Was storage created}
   if(  subStor = nil  ) then
   begin
      ShowMessage(  'Error creating sub-storage'  );
      Exit;
   end;

      {Open the stream for saving the image info to}
   strmImages := subStor.CreateStream(  'Images',  MY_STGM_CREATE  );

      {Images stream created?}
   if(  strmImages = nil  ) then
   begin
      ShowMessage(  'Error Creating stream'  )
   end
   else begin
         {Save image and selected index}
      strmImages.WriteString(   IntToStr(  Node.ImageIndex  ) + #13#10 +
                                IntToStr(  Node.SelectedIndex  )
                             );

   end;

      {Save all children}
   if(  Node.GetFirstChild <> nil  ) then
      Save_CallBack(  Node.GetFirstChild,  subStor  );

      {Save all siblings}
   if(  Node.GetNextSibling <> nil  ) then
      Save_CallBack(  Node.GetNextSibling,  stor  );


   strmImages.Free;
   subStor.Free;
end;



procedure TForm1.but_SaveClick(Sender: TObject);
var
   storFile : TDocFileStorage;
begin
      {Create the file}
   storFile := CreateDocFile(   ExtractFilePath(  Application.ExeName  ) + '\z.ole',
                                MY_STGM_CREATE
                             );

   if(  storFile = nil  ) then
   begin
      ShowMessage(  'Cant create file'  );
      Exit;
   end;

      {Start saving}
   Save_CallBack(  tv_eg5.Items[ 0 ],  storFile  );

      {Done}
   storFile.Free;
end;



procedure Load_CallBack(  Node : TTreeNode;  pData : pointer  );
var
   stor : TDocFileStorage;
   substor : TDocFileStorage;
   strmImages : TDocFileStream;
begin
   stor := TDocFileStorage(pData);
      {Open the storage for this element}
   substor := stor.OpenStorage(  Node.Text,  MY_STGM_OPEN  );

      {Storage opened?}
   if(  substor = nil  ) then
   begin
      ShowMessage(  'Cant open storage ' + Node.Text  );
      Exit;
   end;

      {Open the images stream}
   strmImages := substor.OpenStream(  'Images',  MY_STGM_OPEN  );

      {Stream open?}
   if(  strmImages <> nil  ) then
   begin
      with TStringList.Create do
      begin
            {Load the stream's data into a TString List}
         LoadFromStream(  strmImages  );

         if(  Count > 0  ) then
         begin
               {Get the saved image index}
            Node.ImageIndex := StrToInt(  Strings[ 0 ]  );

            if(  Count > 1  ) then
                  {Get the saved selected index}
               Node.SelectedIndex := StrToInt(  Strings[ 1 ]  );
         end;

         Free;
      end;

         {Close the stream}
      strmImages.Free;
   end;

      {Enum all sub-elements}
   substor.EnumElements(  Form1.LoadName_callback,  substor  );

      {Done with storage}
   substor.Free;
end;



function TForm1.LoadName_callback(  sElementName : WideString;
                                    dwType : DWORD;
                                    pData : pointer
                                  ) : boolean;
var
   Node : TTreeNode;
   OldNode : TTreeNode;
begin
      {Continue enum}
   Result := true;

      {Only interested in storages}
   if(  dwType <> STGTY_STORAGE  ) then
      Exit;

      {Save the node that is currently selected}
   OldNode := tv_eg5.Selected;

      {Add a new node for this element}
   Node := tv_eg5.Items.AddChild(  tv_eg5.Selected,  sElementName  );
      {Select new node}
   Node.Selected := true;

      {Load data and all sub-elements}
   Load_CallBack(  Node,  pData  );

      {Select old node again}
   if(  OldNode <> nil  ) then
      OldNode.Selected := true;
end;



procedure TForm1.but_LoadClick(Sender: TObject);
var
   storFile : TDocFileStorage;
begin
      {Open the file}
   storFile := OpenDocFile(   ExtractFilePath(  Application.ExeName  ) + '\z.ole',
                              MY_STGM_OPEN
                           );

      {Was the DocFile opened}
   if(  storFile = nil  ) then
   begin
      ShowMessage(  'Cant open file'  );
      Exit;
   end;

     {Remove all tree nodes}
   tv_eg5.Items.Clear;

      {Enum all root level elements in the storage file}
   storFile.EnumElements(  LoadName_callback,  storFile  );

      {Done}
   storFile.Free;
end;

end.
