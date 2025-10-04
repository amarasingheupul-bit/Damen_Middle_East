pageextension 50112 JobListS365 extends "Job List"
{
    layout
    {
        addlast(Control1)
        {
            field("PO Created"; Rec."PO Created")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PO Created field.';
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Rec.SetRange("Use as TemplateS365", false);
    end;
}
