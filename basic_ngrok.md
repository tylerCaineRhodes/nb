# basic ngrok

## expose a tcp port to connect to
ngrok tcp 22

## inspect the ngrok window to find the proper port to connect to
Account                       Tyler Rhodes (Plan: Free)
Version                       2.3.40
Region                        United States (us)
Web Interface                 http://127.0.0.1:4040
Forwarding                    tcp://8.tcp.ngrok.io:13890 -> localhost:22

## then the command will look like this
ssh dev@8.tcp.ngrok.io -p13890