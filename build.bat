@echo off
chcp 65001 > nul
set KICAD_CLI="D:\KiCad\bin\kicad-cli.exe"
set PROJECT_NAME=Project_sapr

echo =========================================
echo 1. Запуск проверки электрических правил (ERC)...
%KICAD_CLI% sch erc %PROJECT_NAME%.kicad_sch -o reports/erc_report.rpt

echo =========================================
echo 2. Запуск проверки правил проектирования (DRC)...
%KICAD_CLI% pcb drc %PROJECT_NAME%.kicad_pcb -o reports/drc_report.rpt

echo =========================================
echo 3. Генерация Gerber-файлов...
if not exist gerbers mkdir gerbers
%KICAD_CLI% pcb export gerbers %PROJECT_NAME%.kicad_pcb -o gerbers/

echo =========================================
echo 4. Генерация сверловки (Excellon)...
%KICAD_CLI% pcb export drill %PROJECT_NAME%.kicad_pcb -o gerbers/

echo =========================================
echo 5. Генерация BOM (перечня элементов)...
if not exist reports mkdir reports
%KICAD_CLI% sch export bom %PROJECT_NAME%.kicad_sch -o reports/bom.csv --fields "Refs,Value,Footprint,Qty,DNP,Manufacturer_Part_Number"

echo =========================================
echo 6. Генерация PDF-версии схемы...
%KICAD_CLI% sch export pdf %PROJECT_NAME%.kicad_sch -o reports/schematic.pdf

echo =========================================
echo Сборка завершена!
pause