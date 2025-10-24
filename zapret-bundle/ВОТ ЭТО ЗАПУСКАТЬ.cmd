set "BASE=%~dp0"

set ZAPRET_ARGS=--dpi-desync=split2 --dpi-desync-split-seqovl=681 --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq,hopbyhop2 --dpi-desync-split-seqovl-pattern="%BASE%files\tls_clienthello.bin"
set ZAPRET_ARGS_UDP=--dpi-desync=fake --dpi-desync-autottl=2 --dpi-desync-fooling=badseq --dpi-desync-fake-quic="%BASE%files\zero_64.bin"
set ZAPRET_ARGS_UDP_DISCORD=--dpi-desync=fake --dpi-desync-autottl=2 --dpi-desync-fooling=badseq --dpi-desync-fake-quic="%BASE%files\zero_64.bin"
set ZAPRET_ARGS_QUIC=--dpi-desync=fake --dpi-desync-autottl=2 --dpi-desync-fooling=badseq --dpi-desync-fake-quic="%BASE%files\quic_initial.bin"

set IPSET_AMAZON_CF=--ipset="%BASE%files\amazon_cf.ipset.list"
set HOSTLIST_USER=--hostlist="%BASE%files\user.list"
set HOSTLIST_AUTO=--hostlist-auto="%BASE%files\auto.list"
set HOSTLIST_DEBUG=--hostlist-auto-debug="%BASE%nfqws.log"
set HOSTLIST_EXCLUDE=--hostlist-exclude="%BASE%files\exclude.list"

set ZAPRET_HOSTLISTS=%HOSTLIST_USER% %HOSTLIST_AUTO% %HOSTLIST_DEBUG% %HOSTLIST_EXCLUDE%

start "zapret: http,https,quic" "%BASE%\bin\winws.exe" ^
--wf-tcp=80,443,2000-3000 --wf-udp=443,19300-19400,50000-65535,5055,5056,5058 ^
--comment "VRChat (Photon)"        --filter-udp=5055,5056,5058 %ZAPRET_ARGS_UDP% --new ^
--comment "Discord (STUN/WebRTC)"  --filter-udp=19300-19400,50000-65535 --filter-l7=discord,stun %ZAPRET_ARGS_UDP_DISCORD% --new ^
--comment "TLS/QUIC"               --filter-udp=443 %ZAPRET_ARGS_QUIC% --new ^
--comment "HTTP"                   --filter-tcp=80 --dpi-desync=fake,fakedsplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig %ZAPRET_HOSTLISTS% --new ^
--comment "HTTPs/TLS/Discord RTCs" --filter-tcp=443,2000-3000 %ZAPRET_ARGS% %ZAPRET_HOSTLISTS% --new ^
--comment "LoL (EUNE)"             --filter-tcp=2099 %IPSET_AMAZON_CF% --dpi-desync=syndata
