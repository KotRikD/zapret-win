set "BASE=%~dp0"

set ZAPRET_ARGS=--dpi-desync=fake,split2 --dpi-desync-split-seqovl=681 --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=8 --dpi-desync-split-seqovl-pattern="%BASE%files\tls_clienthello_www_google_com.bin" --dpi-desync-fake-tls-mod=rnd,dupsid,sni=www.google.com
set ZAPRET_ARGS_UDP=--dpi-desync=fake --dpi-desync-repeats=6

set HOSTLIST_USER=--hostlist="%BASE%files\user.list"
set HOSTLIST_AUTO=--hostlist-auto="%BASE%files\auto.list"
set HOSTLIST_DEBUG=--hostlist-auto-debug="%BASE%nfqws.log"
set HOSTLIST_EXCLUDE=--hostlist-exclude="%BASE%files\exclude.list"

set ZAPRET_HOSTLISTS=%HOSTLIST_USER% %HOSTLIST_AUTO% %HOSTLIST_DEBUG% %HOSTLIST_EXCLUDE%

start "zapret: http,https,quic" "%BASE%winws.exe" ^
--wf-tcp=80,443 --wf-udp=443,50000-50099,5065,5066,5068 ^
--filter-udp=50000-50099,5065,5066,5068 --filter-l7=discord,stun %ZAPRET_ARGS_UDP% --new ^
--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic="%BASE%files\quic_initial.bin" --new ^
--filter-tcp=80 --dpi-desync=fake,fakedsplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig %ZAPRET_HOSTLISTS% --new ^
--filter-tcp=443 %ZAPRET_ARGS% %ZAPRET_HOSTLISTS%