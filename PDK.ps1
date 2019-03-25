$ErrorActionPreference = "SilentlyContinue"
cls
$records_value = 0
$SerialNumber = 0
$Mac = 0
$Model = 0
$Manufacturer = 0
$Domain = 0
$CPU = 0

Write-host Proszę wpisać nazwę komputera którego dane mają być pozyskane...
$computer_name = Read-Host
Write-host Sprawdzam czy komputer jest podłączony do sieci...
ping -n 3 $computer_name *>>null
if ("$?" -eq "True"){Write-host Online -ForegroundColor Green}else{
Write-host Offline -ForegroundColor Red
Write-host Zakończono. Zebrano $records_value rekordów.
exit
}
#Program zbiera NAZWE KOMPUTERA, CIID, MAC, SERIALNUMBER, 
Write-host Zaczynam zbierać dane...
Write-host  

Write-host Czytam "SerialNumber" komputera...
$SerialNumber = wmic /node:$computer_name bios get serialnumber
if ("$?" -eq "True"){
($SerialNumber.Message -split '\n')[7]
Write-Host $SerialNumber[2] -ForegroundColor Green
}else{
Write-host Operacja nie powiodła się -ForegroundColor Red
$SerialNumber = "Failed"
}
Write-host
  
Write-host Czytam adres MAC karty przewodowej komputera...
$MacWired = WMIC /node:$computer_name NIC Where "NetConnectionID='Ethernet'" Get MACAddress
if ("$?" -eq "True"){
($MacWired.Message -split '\n')[12]
Write-host ($MacWired[2]) -foregroundcolor green
}else{
Write-host Operacja nie powiodła się -ForegroundColor Red
$MacWired = "Failed"
}
Write-host

Write-host Czytam adres MAC karty bezprzewodowej komputera...
$MacWifi = WMIC /node:$computer_name NIC Where "NetConnectionID='Wi-Fi'" Get MACAddress
if ("$?" -eq "True"){
($MacWifi.Message -split '\n')[12]
Write-host ($MacWifi[2]) -foregroundcolor green
}else{
Write-host Operacja nie powiodła się -ForegroundColor Red
$MacWifi = "Failed"
}
Write-host



Write-host Czytam CI-ID komputera...
$CIID = REG QUERY \\$computer_name\HKLM\SYSTEM\Advicom\ /v InvSerial
if ("$?" -eq "True"){
($CIID.Message -split '\n')[12]
$CIID = $CIID[2]
Write-host ($CIID.Substring(27,8)) -foregroundcolor green
}else{
Write-host Operacja nie powiodła się -ForegroundColor Red
$CIID = "Failed"
}
Write-host

Write-host Czytam model komputera...
$Model = wmic /node:$computer_name computersystem get model
if ("$?" -eq "True"){
($Model.Message -split '\n')[7]
Write-Host $Model[2] -ForegroundColor Green
}else{
Write-host Operacja nie powiodła się -ForegroundColor Red
$Model = "Failed"
}
Write-host

Write-host Czytam producenta komputera...
$Manufacturer = wmic /node:$computer_name baseboard get Manufacturer
if ("$?" -eq "True"){
($Manufacturer.Message -split '\n')[7]
Write-Host $Manufacturer[2] -ForegroundColor Green
}else{
Write-host Operacja nie powiodła się -ForegroundColor Red
$Manufacturer = "Failed"
}
Write-host

Write-host Czytam domene komputera...
$Domain = wmic /node:$computer_name computersystem get domain
if ("$?" -eq "True"){
($Domain.Message -split '\n')[7]
Write-Host $Domain[2] -ForegroundColor Green
}else{
Write-host Operacja nie powiodła się -ForegroundColor Red
$Domain = "Failed"
}
Write-host

if($CIID -eq "Failed"){
Write-host "Wykryto problem z numerem inwentarzowym komputera." -ForegroundColor Red 
Write-host "Zmienić? y/n" -ForegroundColor Green
$flaga = Read-host
if($flaga -eq "y"){
Write-host "Wpisz nowy numer inwentarzowy...   "
$CIID = Read-host
#Tutaj należy zmienić ścieżke rejestru na używaną domyślnie przez firmę
reg add \\$computer_name\HKLM\SYSTEM\CIID\ /v InvSerial /f /t REG_SZ /d $CIID
Write-host "Dodano numer inwentarzowy."
Write-host "W celu poprawnego zapisu wszystkich danych do pliku uruchamiam skrypt ponownie."
Start-Sleep -s 3
.\PDK.ps1
exit
}}
Write-host "Wypisuje dane do pliku..."

Write-host "Nazwa komputera :    $computer_name" *> "$computer_name.txt"
Write-host 'Numer seryjny   :   '$SerialNumber[2] *>> "$computer_name.txt"
Write-host 'MAC adres kabla :   '$MacWired[2] *>> "$computer_name.txt"
Write-host 'MAC adres WIFI  :   '$MacWifi[2] *>> "$computer_name.txt"
Write-host 'InvSerial       :   '($CIID.Substring(27,8)) *>> "$computer_name.txt"
Write-host 'Model           :   '$Model[2] *>> "$computer_name.txt"
Write-host 'Marka           :   '$Manufacturer[2] *>> "$computer_name.txt"
Write-host 'Domena          :   '$Domain[2] *>> "$computer_name.txt"

Write-host "Zakończono." -ForegroundColor Green 
