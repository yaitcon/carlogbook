--------------------------------------------------------
--  DDL for Procedure KIA_REMOTE_CONTROL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "KIA_REMOTE_CONTROL" (p_command in varchar2 ) as
  l_clob varchar2(1000);
begin

if p_command not in ('dooropen','doorlock','stopclimate','climate','startcharge','stopcharge') then 
Raise_Application_Error (-20001, 'Invalid Commando'); 
else
 
 l_clob := to_char(apex_web_service.make_rest_request(
              p_url => 'https://test.glasknochen.at/nodeconnector/?apiendpoint=' || p_command,
              p_http_method => 'GET'));
              

end if;              
end;

/
