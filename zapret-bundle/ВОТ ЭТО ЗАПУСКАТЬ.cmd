@echo off
set "BASE=%~dp0"

:: Подгружаем HTTPs стратегию
call "%BASE%files\load_https_strategy.cmd"

:: Fix TCP меток
call "%BASE%files\ts_timestamps_enabler.cmd"

:: Ставим стандартный набор стратегий
set ZAPRET_ARGS_UDP=--dpi-desync=fake --dpi-desync-autottl=2 --dpi-desync-repeats=10 --dpi-desync-any-protocol=1 --dpi-desync-fake-unknown-udp="%BASE%files\quic_initial.bin" --dpi-desync-cutoff=n2
set ZAPRET_ARGS_QUIC=--dpi-desync=fake --dpi-desync-autottl=2 --dpi-desync-repeats=11 --dpi-desync-fake-quic="%BASE%files\quic_initial.bin"  --dpi-desync-cutoff=n2

:: Здесь вообщем набор файлов, нужный для автолиста
set IPSET=--ipset="%BASE%files\ipset.list" --ipset-ip=0.0.0.0
set HOSTLIST_USER=--hostlist="%BASE%files\user.list"
set HOSTLIST_AUTO=--hostlist-auto="%BASE%files\auto.list"
set HOSTLIST_DEBUG=--hostlist-auto-debug="%BASE%nfqws.log"
set HOSTLIST_EXCLUDE=--hostlist-exclude="%BASE%files\exclude.list"

set ZAPRET_HOSTLISTS=%HOSTLIST_USER% %HOSTLIST_AUTO% %HOSTLIST_DEBUG% %HOSTLIST_EXCLUDE%

start "zapret: http,https,quic" "%BASE%\bin\winws.exe" ^
--wf-tcp=80,443,5222,2000-3000 --wf-udp=443,993-9998,10000-27014,50000-65535 ^
--comment "LoL (EUNE)"             --filter-tcp=2099 %IPSET% --dpi-desync=syndata --new ^
--comment "HTTPS/2"                --filter-tcp=443,5222,2000-3000 %IPSET% %ZAPRET_ARGS% %ZAPRET_HOSTLISTS% --new ^
--comment "UDP"                    --filter-udp=598-600,993-9998,10000-28000,50000-65535 %IPSET% %ZAPRET_ARGS_UDP% --new ^
--comment "TLS/QUIC"               --filter-udp=443 %IPSET% %ZAPRET_ARGS_QUIC%

 
