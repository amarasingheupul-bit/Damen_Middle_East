page 50103 "Ports Code List S365"
{
    ApplicationArea = All;
    Caption = 'Ports Code';
    PageType = List;
    SourceTable = "Ports Code S365";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Enter the unique identifier for the record or port.';
                    ApplicationArea = All;
                }
                field(Descritption; Rec.Descritption)
                {
                    ToolTip = 'Provide a detailed description or name for the record or port.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Select the type or category that defines the purpose of this record.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
