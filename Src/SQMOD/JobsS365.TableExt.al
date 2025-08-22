tableextension 50105 JobsS365 extends Job
{
    fields
    {
        field(50100; "Use as TemplateS365"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Use as Template';
        }
        field(50101; "Quote Type S365"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Quote Type';
            TableRelation = "Quote Type S365"."Code S365";
        }
        modify(Status)
        {
        trigger OnBeforeValidate()
        var
            JobPlanningLine: Record "Job Planning Line";
            Text000Err: Label 'cannot complete without completing..';
        begin
            if Rec.Status = Rec.Status::Completed then begin
                JobPlanningLine.SetRange("Job No.", Rec."No.");
                if JobPlanningLine.FindSet()then repeat if JobPlanningLine."Predecessor Seq S365" > 0 then if not JobPlanningLine."Completed S365" then Error(Text000Err);
                    until JobPlanningLine.Next = 0;
            end;
        end;
        }
    }
    keys
    {
    // Add changes to keys here
    }
    fieldgroups
    {
    // Add changes to field groups here
    }
}
