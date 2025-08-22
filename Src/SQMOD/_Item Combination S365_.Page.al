page 50102 "Item Combination S365"
{
    PageType = List;
    SourceTable = ServiceItemMatrixS365;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Item Cambination Matrix';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Service Item 1 S365"; Rec."Service Item 1 S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the Service Item';
                }
                field("Service Item 2 S365"; Rec."Service Item 2 S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the Service Item';
                }
            }
        }
    }
}
