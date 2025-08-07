pageextension 50117 "4HC Purchase Order List" extends "Purchase Order List"
{
    actions
    {
        modify(Email)
        {
            Enabled = PrintActionEnable;
        }
        modify(Print)
        {
            Enabled = PrintActionEnable;
        }
        modify(Send)
        {
            Enabled = PrintActionEnable;
        }
        modify(AttachAsPDF)
        {
            Enabled = PrintActionEnable;
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if Rec.Status = Rec.Status::Released then
            PrintActionEnable := true
        else
            PrintActionEnable := false;
    end;

    var
        PrintActionEnable: Boolean;
}