--------------------------------------------------------
--  DDL for Procedure GET_KIA_REPORT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "GET_KIA_REPORT" as
  l_clob varchar2(1000);
begin

 l_clob := to_char(apex_web_service.make_rest_request(
              p_url => 'https://test.glasknochen.at/nodeconnector/?apiendpoint=drivehistory',
              p_http_method => 'GET'));

 l_clob := to_char(apex_web_service.make_rest_request(
              p_url => 'https://test.glasknochen.at/nodeconnector/?apiendpoint=monthlyreport',
              p_http_method => 'GET'));
              
end;

/
