
function [text] = textbox_lifetime(lifetime,rms)
         
lifetime_str = string(lifetime)
head1 = "Lifetime(ps)";
head2 = "_ _ _ _ _ _ _";

head3 = "RMS"
head4 = "**********"

text = vertcat(head1,head2,lifetime_str,head4,head3,head2,rms)
%           cellArrayText{1 = rms
%           cellArrayText{2} = cl
          
%           otxa = uitextarea
%           otxa.Value = text;
