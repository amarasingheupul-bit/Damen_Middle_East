page 50100 PackageTypeListS365
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = PackageTypeS365;
    Caption = 'Package Type List';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ToolTip = 'Specify the package code';
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specify the description';
                    ApplicationArea = all;
                }
            }
        }
    }
}
