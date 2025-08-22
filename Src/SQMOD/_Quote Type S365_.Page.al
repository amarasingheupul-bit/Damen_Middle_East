page 50101 "Quote Type S365"
{
    ApplicationArea = All;
    Caption = 'Quote Type';
    PageType = List;
    SourceTable = "Quote Type S365";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code S365"; Rec."Code S365")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field("Discription S365"; Rec."Discription S365")
                {
                    ToolTip = 'Specifies the value of the Discription field.', Comment = '%';
                }
            }
        }
    }
}
