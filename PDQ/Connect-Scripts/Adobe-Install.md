## Install steps

- Step 1. 
  - Download the adobe 64bit installer
- Step 2. 
  - Install adobe reader on some machine
- Step 3.
  - After install you can go into `C:\Program Files\Common Files\Adobe\Acrobat\Setup\<id>`
  - `<id>` will be some random guid
- Step 4.
  - in that folder there will be a `.msi`, `.msp` and a `.cab` file. Copy those to connect in a file copy step
- Step 5.
  - Create a script step, and paste in the contents of the `Adobe-Install.sh` script


## Things to look out for

- make sure that the `.msp` file name in the script matches the file name of the one you are copying