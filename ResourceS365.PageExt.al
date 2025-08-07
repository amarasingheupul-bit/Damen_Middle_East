pageextension 50108 ResourceS365 extends "Resource Card"
{
    layout
    {
        addlast(General)
        {
            field(EmailS365; Rec.TransportManagerS365)
            {
                ToolTip = 'Specify the Transport Manager';
                ApplicationArea = all;
            }
        }
    }
}
