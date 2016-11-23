unit TreeUtils;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;



function IsDuplicateName(  Node : TTreeNode;
                           sNewName : string;
                           bInclusive : boolean
                         ) : boolean;

   {Checks if IsParentNode is a parent of IsChildNode}
function IsAParentNode(  IsParentNode,  IsChildNode  : TTreeNode  ) : boolean;

   {Moves Source node to DestNode (as a child!)}
procedure MoveTreeNode(  tv : TTreeView;  SourceNode,  DestNode  : TTreeNode  );


implementation

function IsDuplicateName(  Node : TTreeNode;
                           sNewName : string;
                           bInclusive : boolean
                         ) : boolean;
var
   TestNode : TTreeNode;
begin
   if(  Node = nil  ) then
   begin
      Result := false;
      Exit;
   end;

      {Include this Node?}
   if(  bInclusive  ) then
      if(   CompareText(  Node.Text,  sNewName  ) = 0   ) then
      begin
         Result := true;
         Exit;
      end;


      {Test all previous siblings}
   TestNode := Node;
   repeat
         {Get next}
      TestNode := TestNode.GetPrevSibling;

      if(  TestNode <> nil  ) then
            {Is this a duplicate}
         if(   CompareText(  TestNode.Text,  sNewName  ) = 0   ) then
         begin
            Result := true;
            Exit;
         end;
   until (TestNode = nil);


      {Test all next siblings}
   TestNode := Node;
   repeat
         {Get next}
      TestNode := TestNode.GetNextSibling;

      if(  TestNode <> nil  ) then
            {Is this a duplicate}
         if(   CompareText(  TestNode.Text,  sNewName  ) = 0   ) then
         begin
            Result := true;
            Exit;
         end;
   until (TestNode = nil);

   Result := false;
end;



function IsAParentNode(  IsParentNode,  IsChildNode  : TTreeNode  ) : boolean;
var
   Node : TTreeNode;
begin;
   if(  IsChildNode = nil  ) then
   begin
      Result := false;
      Exit;
   end;

      {Is this node = parent?}
   if(  IsParentNode = IsChildNode  ) then
   begin
      Result := true;
      Exit;
   end;

      {Get parent}
   Node := IsChildNode.Parent;

      {Recursivly test all parents}
   Result := IsAParentNode(  IsParentNode,  Node  );
end;



procedure MoveTreeNode(  tv : TTreeView;  SourceNode,  DestNode  : TTreeNode  );
   procedure MoveTreeNode_internal(  DontMoveSiblings,  SourceNode,  DestNode  : TTreeNode  );
   var
      NewNode : TTreeNode;
   begin
      if(  DestNode = nil  ) then
         Exit;
      if(  SourceNode = nil  ) then
         Exit;

         {Create new child}
      NewNode := tv.Items.AddChild(  DestNode,  SourceNode.Text  );
         {Use same images}
      NewNode.ImageIndex := SourceNode.ImageIndex;
      NewNode.SelectedIndex := SourceNode.SelectedIndex;
      NewNode.Data := SourceNode.Data;


         {If this node has children move them first}
      if(  SourceNode.HasChildren  ) then
         MoveTreeNode_internal(  DontMoveSiblings,  SourceNode.GetFirstChild,  NewNode  );

         {Move all siblings, unless at original level}
      if(  DontMoveSiblings <> SourceNode  ) then
         MoveTreeNode_internal(  DontMoveSiblings,  SourceNode.GetNextSibling,  DestNode  );
    end;
begin
      {Copy node + children}
   MoveTreeNode_internal(  SourceNode,  SourceNode,  DestNode  );
      {Delete original}
   SourceNode.Delete;
end;






end.
