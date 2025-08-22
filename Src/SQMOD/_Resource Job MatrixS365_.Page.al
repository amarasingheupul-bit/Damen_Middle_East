page 50107 "Resource Job MatrixS365"
{
    PageType = List;
    SourceTable = "ResourceJobMatrixS365";
    ApplicationArea = All;
    Caption = 'Transport Resource Matrix';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Resource No."; Rec."Resource No.")
                {
                    ApplicationArea = All;
                }
                field("Date"; rec."Date")
                {
                    ApplicationArea = All;
                }
                field("Job Count"; Rec."Job Count")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(LoadMatrix)
            {
                ApplicationArea = All;
                Caption = 'Load Data';

                trigger OnAction()
                begin
                    LoadMatrixData();
                end;
            }
        }
    }
    procedure LoadMatrixData()
    var
        TempResourceJobMatrix: Record "ResourceJobMatrixS365" temporary;
        Resource: Record Resource;
        JobLedgerEntry: Record "Job Ledger Entry";
        StartDate, EndDate, CurrentDate: Date;
        Jobs: Record Job;
        JobPlanningLines: Record "Job Planning Line";
        JobNo: Code[20];
        JobCount: Integer;
    begin
        // Define Date Range
        StartDate:=CalcDate('-<CM>', Today);
        EndDate:=CalcDate('<CW>', Today);
        Clear(TempResourceJobMatrix);
        Resource.Reset();
        if Resource.FindSet()then repeat while CurrentDate <= EndDate do begin
                    JobCount:=0;
                    JobPlanningLines.SetCurrentKey("Job No.");
                    JobPlanningLines.SetRange(Type, JobPlanningLines.Type::Resource);
                    JobPlanningLines.SetRange("No.", Resource."No.");
                    JobPlanningLines.SetRange("Planning Date", CurrentDate);
                    if JobPlanningLines.FindSet()then repeat if JobNo <> JobPlanningLines."Job No." then begin
                                JobCount+=1;
                            end;
                            JobNo:=JobPlanningLines."Job No.";
                        until JobPlanningLines.Next() = 0;
                    TempResourceJobMatrix.Init();
                    TempResourceJobMatrix."Resource No.":=Resource."No.";
                    TempResourceJobMatrix."Date":=CurrentDate;
                    TempResourceJobMatrix."Job Count":=JobCount;
                    TempResourceJobMatrix.Insert();
                    CurrentDate:=CurrentDate + 1; // Move to the next date
                end;
            until Resource.Next() = 0;
        CurrPage.Update();
    end;
}
