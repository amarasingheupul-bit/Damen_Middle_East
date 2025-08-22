pageextension 50112 JobListS365 extends "Job List"
{
    trigger OnAfterGetRecord()
    begin
        Rec.SetRange("Use as TemplateS365", false);
    end;
}
