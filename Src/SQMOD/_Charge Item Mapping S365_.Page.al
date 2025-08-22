page 50120 "Charge Item Mapping S365"
{
    PageType = List;
    SourceTable = "Charge Item MappingS365";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Charge Item Mapping';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the item no.';
                }
                field("Charge Item No."; Rec."Charge Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the charge item no.';
                }
            }
        }
    }
}
