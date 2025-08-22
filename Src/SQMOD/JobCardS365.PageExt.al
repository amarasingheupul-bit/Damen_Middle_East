pageextension 50106 JobCardS365 extends "Job Card"
{
    layout
    {
        addlast(General)
        {
            field("Use as TemplateS365"; Rec."Use as TemplateS365")
            {
                ApplicationArea = All;
                ToolTip = 'Specify if the job is use as a template';
            }
            field("Quote Type S365"; Rec."Quote Type S365")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quote Type field.';
                TableRelation = "Quote Type S365"."Code S365";
            }
        }
    }
}
