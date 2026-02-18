pageextension 50132 "Sales & Receivables SetupExt" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Number Series")
        {
            group(JobValidation)
            {
                Caption = 'Job Validation';

                field("Skip Job Validation on Sales"; Rec."Skip Job Validation on Sales")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enable to skip mandatory job validation during sales posting';
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}