page 50108 ProjectTemplateS365
{
    Caption = 'Project Template List';
    PageType = List;
    ApplicationArea = all;
    UsageCategory = Lists;
    SourceTable = Job;
    SourceTableView = where("Use as TemplateS365"=filter(true));
    CardPageID = "Job Card";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(JobNo; Rec."No.")
                {
                }
                field(JobDescription; Rec.Description)
                {
                }
            }
        }
    }
}
