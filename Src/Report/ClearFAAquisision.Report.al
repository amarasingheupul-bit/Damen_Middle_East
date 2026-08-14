report 50109 "Clear FA Aquisition Report"
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Clear FA Aquisition Report';
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Fixed Asset" = RIMD;

    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            RequestFilterFields = "No.";
            trigger OnAfterGetRecord()
            begin

                "Fixed Asset".Acquired := false;
                "Fixed Asset".Modify(true);
            end;

        }
    }
}