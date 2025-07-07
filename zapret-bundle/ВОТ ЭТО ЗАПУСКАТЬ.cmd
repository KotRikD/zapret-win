set "BASE=%~dp0"

set ZAPRET_ARGS=--dpi-desync=fakedsplit --dpi-desync-split-pos=1 --dpi-desync-ttl=0 --dpi-desync-repeats=16 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls-mod=padencap --dpi-desync-fake-tls="%BASE%files\tls_clienthello.bin"
set ZAPRET_ARGS_UDP=--dpi-desync=fake --dpi-desync-repeats=6

set IPSET_AMAZON_CF=--ipset="%BASE%files\amazon_cf.ipset.list"
set HOSTLIST_USER=--hostlist="%BASE%files\user.list"
set HOSTLIST_AUTO=--hostlist-auto="%BASE%files\auto.list"
set HOSTLIST_DEBUG=--hostlist-auto-debug="%BASE%nfqws.log"
set HOSTLIST_EXCLUDE=--hostlist-exclude="%BASE%files\exclude.list"

set ZAPRET_HOSTLISTS=%HOSTLIST_USER% %HOSTLIST_AUTO% %HOSTLIST_DEBUG% %HOSTLIST_EXCLUDE%

start "zapret: http,https,quic" "%BASE%winws.exe" ^
--wf-tcp=80,443,2099 --wf-udp=443,50000-50099,5055,5056,5058 ^
--filter-udp=50000-50099,5055,5056,5058 --filter-l7=discord,stun %ZAPRET_ARGS_UDP% --new ^
--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic="%BASE%files\quic_initial.bin" --new ^
--filter-tcp=80 --dpi-desync=fake,fakedsplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig %ZAPRET_HOSTLISTS% --new ^
--filter-tcp=443 %ZAPRET_ARGS% %ZAPRET_HOSTLISTS% --new ^
--filter-tcp=2099 %IPSET_AMAZON_CF% --dpi-desync=syndata