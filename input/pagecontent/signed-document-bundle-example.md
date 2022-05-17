
<!-- # Da Vinci CDEX Digital Signature Document Bundle Example -->

This is a Jupyter Notebook which uses openSSL, Python 3.7, and the Python jcs and jose libraries to create a JSON Web Signature (JWS) (see RFC 7515), attach it to a FHIR Bundle and validate it. Its source code be found [here](https://github.com/HL7/davinci-ecdx/blob/master/CDEX-Signatures/Digsig_Document_Bundle_Example.ipynb)

*Although self-signed certificates are used for the purpose of these examples, they are not recommended for production systems.*

### Sender/Signer Steps

**1. Generate RSA256 public and private keys for signing the bundle**

*DO THIS STEP ONLY ONCE*

**2. Create a self-signed certificate for authenticating the signer**

create the public and private keys and cert using openssl on the command line.

1. pre-configure the self-signed cert with a configuration file

~~~
[req]
default_bit = 4096
distinguished_name = req_distinguished_name
prompt = no
x509_extensions = v3_ca

[req_distinguished_name]
countryName             = US
stateOrProvinceName     = California
localityName            = Sausalito
organizationName        = HealtheData1
commonName              = Eric Haas, DVM
emailAddress            = ehaas@healthedata1.org

[v3_ca]
basicConstraints = CA:TRUE
keyUsage=nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = www.healthedatainc.com
~~~

2\. generate the public and private keys and cert

~~~
!openssl genrsa -out private-key.pem 3072
!openssl rsa -in private-key.pem -pubout -out public-key.pem
!openssl req -new -x509 -key private-key.pem -outform DER -out cert.der -days 360 -config cert.config
~~~

*For the purpose of this example display the keys (normally would never share the private key)*


```python
!cat private-key.pem
!echo
!cat public-key.pem
```


<pre style="border:0; overflow-wrap:break-word;">
-----BEGIN RSA PRIVATE KEY-----
MIIG4wIBAAKCAYEA6SnEpKADOrFttfr1k3iFThsddDFmrEMu1R4nes8qlwATPs53
wZ13p8lNI9RU7z5kXzg6Dg11bj1MA6JoQh4fm3JVvSjNqOet3MUShLwZ2h67I8Oc
jZsTuWIxEW4bR3UHqpLXcN1WBEUfR6MSztxZLM0dvdh0weMVt8lpVd4E5DEKMz0n
CSh92xvD6qugGDyewuGASJVEnQTFZd6p3hH4O37sYhX16H3U1Zu6zIohu1/c+Nz3
4pamnorH5rUcQJUcBDV6x9zrzgz8i9K05xvArGwF2FSDJnXR3uGRfaZYfebI+KTE
4S7XCV/6PVxy44exJmcoCR1hEKuD8BcGXZm3H4Qpjq/PB/AW1K7v+1es27BtTdQl
pZ3ZW1c5y/tyDDq/JF2h3Gp6n3JIBVeBK534xSatTiGgJrDI/OcTJI8ly8nCy/7u
Z9qOgYPd/1EX6rjqEiBjgkduQ2mc6cNpN7O6BPXTMBFl7X14GLYdm5Y8ubRR9Bo6
TpMdO4+2U+R58Z5bAgMBAAECggGANf/QZPgSB2PULtNCULcW2HH7Lk/KoZaloAHt
zslv6azAyEj0/0hCz/8U+HlSel4OzOauu1ZunetgUW8pijaDx3KBXN+4UafmYjzZ
/xe5PQTk/nFtLnZ96O9OweSoOLJn5h8/+gmoxDBmACdKUdJCbNfMTY117Pl0rC3f
UV2r8FVTMW62Pa69ByO1CgJZf4N6mVO0bBr12w+hz+fzm1S6Er1gbY78dq29vwLk
Dj7ndQfMm25Bkp6lVA58IXhMZMCjXSbei1aHxYBXAcAJP5bouiAxqnb2rZ5QM1W1
CpLuJ0HbGGl0y6aWZenV/C5JEDKqqh62KUGPnTeJLgpJpnuK59y7K+0dcFFKji5C
0d61lTaOKxHz3X11043j9+pJYJ8bEpxwimO+1i6boBNrB++i5cC8UKxK0Zw6o3HW
Xfko57EJR6oCiWeorgHZTF6wud4WlRkOMrt7EkrhbPQF8lcahCKGCwI63wxcCtE6
Wf784Dto+kQSQj6+G2V385utiXExAoHBAP95t1kQdTQl3ASwA3wvnU1oRzsj83DS
Qrg2vhJlhTUwKIsxKYIvL/KQQFsd4/ejr5nGurlAcFsRlA6cR94LXL2DWvvy52uP
r1UeOPeJ7DiFu2IY8ehtX9wEbt1dLYkgwTmkwASQIJsaNCgMH+1y5jcWdWGmHqf8
Y4z3/JerrT1FRT/Sgsp34HrzeCAajyRLK/qzDU1ieXYWVMnv+ZGEl5DFMvFRf0dP
IJHT7uuHdAvXw1tRcvsYtGIdiHyNDGjcpQKBwQDppFL2n50Fx3oWanXIspWS4Whq
PgBm2wTz5o+LGQIRj0m6qD5q+/mXdxxzj8zY3qlkQj1YGT2Bog9cYL2+PuNqnHeq
coi6uVf0zruq9XcrCoYs5sT4GT57LdRQK3xtGXURFbrVc/wjn7rU1/XhqThQADGx
cHvUVc37Pkvirf0/hAkW3KwOBEsXn8IYJ5JydBOm957NvoEAGCcI9tc0FM7xl4I7
CMzSYl+i/tXy/sec45Y514LXun8Tvm09uj8Qnv8CgcBX7HDwgxyDLQBy0IzygYSW
rmvNa8sNqh9yPMzfkfbtXjyl4u6RMmJDDehIM5pQkRIPT3jV5tqETSFygdCuF6T8
SCfZDDkfKJ1EIxmh/+K/dS8PTNx8jJ/wHcp1/up8BjzZ9Nxs9ZlzJ+qJWdrnIqMe
lGkjiUOFtvQgAPz6ygfeTWfO1klTGzyzs/VEvz9CU2i4aEUMu/ZncLoPobp3nXV4
SpYEvXKbfR0Ncy4H+18x8Dj4xahXyKHUHqvpibWapU0CgcEAinvgxNd0neFPZwvx
BmV7rJS4bAiV+mElPV/SgzLue/P/Uoi4fncdyH5MOd7pHz5TDt8INzi2sSiajDm3
HZVu/FkDwN6kVnDXRn5m0/0shjF1uBWMeDWWSDKw3lf4Jz5omhjUJgLaV08s0U20
Ku4/N4P18GNoskGtlpalKhXQvp4HOSrRPHmk/Lqvs9t4vSg6IcQxt2eMVL78HB8b
DX6r7pzMDyu3I5g1cYo0zBPhwwdOmrg3kKC1A8HiRC0phjOHAoHAbayWoC7XWsKx
1XzirFof87u47oEAcu0VlOJOwCr270J2Q1jyLMRCvgNQYvZz6nTJt0jcXazZrBTQ
jkwHgb7kFFSTqrE3Uj8Bmm6O+WnoY2+zi4leSe8yz3SRpLL1w9S1p40XQGLJhIX+
GJr5shr9osadWap/vzl244Do4Od/NMehLl6ibyu1UteRexDp8JjyUBwAAC50kMYP
OavUzEG9Ymb4t4yNjaso6C7ZNVcbJTJeI1A153p0uH3xJqFefai2
-----END RSA PRIVATE KEY-----

-----BEGIN PUBLIC KEY-----
MIIBojANBgkqhkiG9w0BAQEFAAOCAY8AMIIBigKCAYEA6SnEpKADOrFttfr1k3iF
ThsddDFmrEMu1R4nes8qlwATPs53wZ13p8lNI9RU7z5kXzg6Dg11bj1MA6JoQh4f
m3JVvSjNqOet3MUShLwZ2h67I8OcjZsTuWIxEW4bR3UHqpLXcN1WBEUfR6MSztxZ
LM0dvdh0weMVt8lpVd4E5DEKMz0nCSh92xvD6qugGDyewuGASJVEnQTFZd6p3hH4
O37sYhX16H3U1Zu6zIohu1/c+Nz34pamnorH5rUcQJUcBDV6x9zrzgz8i9K05xvA
rGwF2FSDJnXR3uGRfaZYfebI+KTE4S7XCV/6PVxy44exJmcoCR1hEKuD8BcGXZm3
H4Qpjq/PB/AW1K7v+1es27BtTdQlpZ3ZW1c5y/tyDDq/JF2h3Gp6n3JIBVeBK534
xSatTiGgJrDI/OcTJI8ly8nCy/7uZ9qOgYPd/1EX6rjqEiBjgkduQ2mc6cNpN7O6
BPXTMBFl7X14GLYdm5Y8ubRR9Bo6TpMdO4+2U+R58Z5bAgMBAAE=
-----END PUBLIC KEY-----
</pre>

Show the Certificate in DER Format


```python
!openssl x509 -in cert.der -inform DER -text
```

<pre style="border:0; overflow-wrap:break-word;">
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 16322561221100825744 (0xe28562f33047ec90)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=US, ST=California, L=Sausalito, O=HealtheData1, CN=Eric Haas, DVM/emailAddress=ehaas@healthedata1.org
        Validity
            Not Before: Oct 27 17:42:04 2021 GMT
            Not After : Oct 22 17:42:04 2022 GMT
        Subject: C=US, ST=California, L=Sausalito, O=HealtheData1, CN=Eric Haas, DVM/emailAddress=ehaas@healthedata1.org
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (3072 bit)
                Modulus:
                    00:e9:29:c4:a4:a0:03:3a:b1:6d:b5:fa:f5:93:78:
                    85:4e:1b:1d:74:31:66:ac:43:2e:d5:1e:27:7a:cf:
                    2a:97:00:13:3e:ce:77:c1:9d:77:a7:c9:4d:23:d4:
                    54:ef:3e:64:5f:38:3a:0e:0d:75:6e:3d:4c:03:a2:
                    68:42:1e:1f:9b:72:55:bd:28:cd:a8:e7:ad:dc:c5:
                    12:84:bc:19:da:1e:bb:23:c3:9c:8d:9b:13:b9:62:
                    31:11:6e:1b:47:75:07:aa:92:d7:70:dd:56:04:45:
                    1f:47:a3:12:ce:dc:59:2c:cd:1d:bd:d8:74:c1:e3:
                    15:b7:c9:69:55:de:04:e4:31:0a:33:3d:27:09:28:
                    7d:db:1b:c3:ea:ab:a0:18:3c:9e:c2:e1:80:48:95:
                    44:9d:04:c5:65:de:a9:de:11:f8:3b:7e:ec:62:15:
                    f5:e8:7d:d4:d5:9b:ba:cc:8a:21:bb:5f:dc:f8:dc:
                    f7:e2:96:a6:9e:8a:c7:e6:b5:1c:40:95:1c:04:35:
                    7a:c7:dc:eb:ce:0c:fc:8b:d2:b4:e7:1b:c0:ac:6c:
                    05:d8:54:83:26:75:d1:de:e1:91:7d:a6:58:7d:e6:
                    c8:f8:a4:c4:e1:2e:d7:09:5f:fa:3d:5c:72:e3:87:
                    b1:26:67:28:09:1d:61:10:ab:83:f0:17:06:5d:99:
                    b7:1f:84:29:8e:af:cf:07:f0:16:d4:ae:ef:fb:57:
                    ac:db:b0:6d:4d:d4:25:a5:9d:d9:5b:57:39:cb:fb:
                    72:0c:3a:bf:24:5d:a1:dc:6a:7a:9f:72:48:05:57:
                    81:2b:9d:f8:c5:26:ad:4e:21:a0:26:b0:c8:fc:e7:
                    13:24:8f:25:cb:c9:c2:cb:fe:ee:67:da:8e:81:83:
                    dd:ff:51:17:ea:b8:ea:12:20:63:82:47:6e:43:69:
                    9c:e9:c3:69:37:b3:ba:04:f5:d3:30:11:65:ed:7d:
                    78:18:b6:1d:9b:96:3c:b9:b4:51:f4:1a:3a:4e:93:
                    1d:3b:8f:b6:53:e4:79:f1:9e:5b
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints:
                CA:TRUE
            X509v3 Key Usage:
                Digital Signature, Non Repudiation, Key Encipherment
            X509v3 Subject Alternative Name:
                DNS:www.healthedatainc.com
    Signature Algorithm: sha256WithRSAEncryption
         0a:e3:14:36:af:5a:cb:ef:9e:e5:80:bb:40:53:bd:e2:b7:f3:
         c4:64:27:17:71:a4:95:93:40:5e:62:2b:ec:f5:46:76:21:98:
         d8:64:f1:ff:d4:6d:1c:2c:13:2b:39:0b:fb:2b:ca:a2:37:99:
         f5:d5:4a:f3:0a:c6:56:24:64:3b:f8:d4:c9:9f:8a:71:64:68:
         91:48:ec:e7:d9:dc:24:64:4c:49:24:71:b5:e0:90:ba:3b:78:
         85:fd:be:fe:a5:7e:7f:6b:0c:42:d1:2b:c0:f1:37:d2:f6:ea:
         45:85:0d:34:d0:55:11:0a:5a:43:1f:da:70:90:d4:bf:db:fb:
         b2:31:e2:24:3a:97:c1:0f:ab:ce:3f:79:88:70:08:69:e1:07:
         a8:5f:cc:b3:6d:a9:d9:b7:99:ba:ab:c8:40:a7:8c:97:eb:2f:
         56:a1:ed:8a:ec:d6:9c:5e:14:e9:52:26:a6:4a:f8:6c:79:7b:
         7a:05:7d:1f:a9:7a:4f:64:8c:92:3e:aa:0d:4e:5e:f4:d8:34:
         66:52:d3:b6:8b:2c:84:12:e6:a2:91:7b:7b:b1:f2:ad:31:00:
         99:f3:8f:29:07:b4:12:0f:44:da:ea:f3:c6:a0:6e:1b:9e:24:
         e7:41:b6:27:41:62:3e:c4:09:02:11:62:34:6c:12:83:84:b7:
         1f:25:43:1b:bb:9e:29:dd:0b:f7:7c:0a:38:d3:98:1a:f3:0a:
         8b:30:87:07:ea:4a:bc:43:09:a1:9f:32:f6:e8:81:f8:71:57:
         72:9f:51:68:9a:89:f7:b1:e9:65:31:2f:fa:58:82:a7:63:d2:
         5f:37:0a:d2:bd:b9:49:cc:a3:17:a7:4b:a2:e2:b6:48:1d:f4:
         c4:0b:c9:f2:d1:39:f3:8f:a3:a9:0e:82:19:e7:14:f5:78:ef:
         94:08:ee:25:d0:ab:0d:e5:4f:b2:39:27:ec:e3:d7:1b:ef:17:
         65:4e:f3:a8:76:4d:99:75:f5:61:8e:07:e6:b8:04:27:8f:25:
         ad:4a:cf:dc:8f:11
-----BEGIN CERTIFICATE-----
MIIE3zCCA0egAwIBAgIJAOKFYvMwR+yQMA0GCSqGSIb3DQEBCwUAMIGNMQswCQYD
VQQGEwJVUzETMBEGA1UECAwKQ2FsaWZvcm5pYTESMBAGA1UEBwwJU2F1c2FsaXRv
MRUwEwYDVQQKDAxIZWFsdGhlRGF0YTExFzAVBgNVBAMMDkVyaWMgSGFhcywgRFZN
MSUwIwYJKoZIhvcNAQkBFhZlaGFhc0BoZWFsdGhlZGF0YTEub3JnMB4XDTIxMTAy
NzE3NDIwNFoXDTIyMTAyMjE3NDIwNFowgY0xCzAJBgNVBAYTAlVTMRMwEQYDVQQI
DApDYWxpZm9ybmlhMRIwEAYDVQQHDAlTYXVzYWxpdG8xFTATBgNVBAoMDEhlYWx0
aGVEYXRhMTEXMBUGA1UEAwwORXJpYyBIYWFzLCBEVk0xJTAjBgkqhkiG9w0BCQEW
FmVoYWFzQGhlYWx0aGVkYXRhMS5vcmcwggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAw
ggGKAoIBgQDpKcSkoAM6sW21+vWTeIVOGx10MWasQy7VHid6zyqXABM+znfBnXen
yU0j1FTvPmRfODoODXVuPUwDomhCHh+bclW9KM2o563cxRKEvBnaHrsjw5yNmxO5
YjERbhtHdQeqktdw3VYERR9HoxLO3FkszR292HTB4xW3yWlV3gTkMQozPScJKH3b
G8Pqq6AYPJ7C4YBIlUSdBMVl3qneEfg7fuxiFfXofdTVm7rMiiG7X9z43Pfilqae
isfmtRxAlRwENXrH3OvODPyL0rTnG8CsbAXYVIMmddHe4ZF9plh95sj4pMThLtcJ
X/o9XHLjh7EmZygJHWEQq4PwFwZdmbcfhCmOr88H8BbUru/7V6zbsG1N1CWlndlb
VznL+3IMOr8kXaHcanqfckgFV4ErnfjFJq1OIaAmsMj85xMkjyXLycLL/u5n2o6B
g93/URfquOoSIGOCR25DaZzpw2k3s7oE9dMwEWXtfXgYth2bljy5tFH0GjpOkx07
j7ZT5HnxnlsCAwEAAaNAMD4wDAYDVR0TBAUwAwEB/zALBgNVHQ8EBAMCBeAwIQYD
VR0RBBowGIIWd3d3LmhlYWx0aGVkYXRhaW5jLmNvbTANBgkqhkiG9w0BAQsFAAOC
AYEACuMUNq9ay++e5YC7QFO94rfzxGQnF3GklZNAXmIr7PVGdiGY2GTx/9RtHCwT
KzkL+yvKojeZ9dVK8wrGViRkO/jUyZ+KcWRokUjs59ncJGRMSSRxteCQujt4hf2+
/qV+f2sMQtErwPE30vbqRYUNNNBVEQpaQx/acJDUv9v7sjHiJDqXwQ+rzj95iHAI
aeEHqF/Ms22p2beZuqvIQKeMl+svVqHtiuzWnF4U6VImpkr4bHl7egV9H6l6T2SM
kj6qDU5e9Ng0ZlLTtosshBLmopF7e7HyrTEAmfOPKQe0Eg9E2urzxqBuG54k50G2
J0FiPsQJAhFiNGwSg4S3HyVDG7ueKd0L93wKONOYGvMKizCHB+pKvEMJoZ8y9uiB
+HFXcp9RaJqJ97HpZTEv+liCp2PSXzcK0r25ScyjF6dLouK2SB30xAvJ8tE584+j
qQ6CGecU9XjvlAjuJdCrDeVPsjkn7OPXG+8XZU7zqHZNmXX1YY4H5rgEJ48lrUrP
3I8R
-----END CERTIFICATE-----
</pre>

Show the Certificate in PEM format


```python
!openssl x509 -in cert.der -inform DER -outform PEM -out cert.pem
!cat cert.pem
```

<pre style="border:0; overflow-wrap:break-word;">
-----BEGIN CERTIFICATE-----
MIIE3zCCA0egAwIBAgIJAOKFYvMwR+yQMA0GCSqGSIb3DQEBCwUAMIGNMQswCQYD
VQQGEwJVUzETMBEGA1UECAwKQ2FsaWZvcm5pYTESMBAGA1UEBwwJU2F1c2FsaXRv
MRUwEwYDVQQKDAxIZWFsdGhlRGF0YTExFzAVBgNVBAMMDkVyaWMgSGFhcywgRFZN
MSUwIwYJKoZIhvcNAQkBFhZlaGFhc0BoZWFsdGhlZGF0YTEub3JnMB4XDTIxMTAy
NzE3NDIwNFoXDTIyMTAyMjE3NDIwNFowgY0xCzAJBgNVBAYTAlVTMRMwEQYDVQQI
DApDYWxpZm9ybmlhMRIwEAYDVQQHDAlTYXVzYWxpdG8xFTATBgNVBAoMDEhlYWx0
aGVEYXRhMTEXMBUGA1UEAwwORXJpYyBIYWFzLCBEVk0xJTAjBgkqhkiG9w0BCQEW
FmVoYWFzQGhlYWx0aGVkYXRhMS5vcmcwggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAw
ggGKAoIBgQDpKcSkoAM6sW21+vWTeIVOGx10MWasQy7VHid6zyqXABM+znfBnXen
yU0j1FTvPmRfODoODXVuPUwDomhCHh+bclW9KM2o563cxRKEvBnaHrsjw5yNmxO5
YjERbhtHdQeqktdw3VYERR9HoxLO3FkszR292HTB4xW3yWlV3gTkMQozPScJKH3b
G8Pqq6AYPJ7C4YBIlUSdBMVl3qneEfg7fuxiFfXofdTVm7rMiiG7X9z43Pfilqae
isfmtRxAlRwENXrH3OvODPyL0rTnG8CsbAXYVIMmddHe4ZF9plh95sj4pMThLtcJ
X/o9XHLjh7EmZygJHWEQq4PwFwZdmbcfhCmOr88H8BbUru/7V6zbsG1N1CWlndlb
VznL+3IMOr8kXaHcanqfckgFV4ErnfjFJq1OIaAmsMj85xMkjyXLycLL/u5n2o6B
g93/URfquOoSIGOCR25DaZzpw2k3s7oE9dMwEWXtfXgYth2bljy5tFH0GjpOkx07
j7ZT5HnxnlsCAwEAAaNAMD4wDAYDVR0TBAUwAwEB/zALBgNVHQ8EBAMCBeAwIQYD
VR0RBBowGIIWd3d3LmhlYWx0aGVkYXRhaW5jLmNvbTANBgkqhkiG9w0BAQsFAAOC
AYEACuMUNq9ay++e5YC7QFO94rfzxGQnF3GklZNAXmIr7PVGdiGY2GTx/9RtHCwT
KzkL+yvKojeZ9dVK8wrGViRkO/jUyZ+KcWRokUjs59ncJGRMSSRxteCQujt4hf2+
/qV+f2sMQtErwPE30vbqRYUNNNBVEQpaQx/acJDUv9v7sjHiJDqXwQ+rzj95iHAI
aeEHqF/Ms22p2beZuqvIQKeMl+svVqHtiuzWnF4U6VImpkr4bHl7egV9H6l6T2SM
kj6qDU5e9Ng0ZlLTtosshBLmopF7e7HyrTEAmfOPKQe0Eg9E2urzxqBuG54k50G2
J0FiPsQJAhFiNGwSg4S3HyVDG7ueKd0L93wKONOYGvMKizCHB+pKvEMJoZ8y9uiB
+HFXcp9RaJqJ97HpZTEv+liCp2PSXzcK0r25ScyjF6dLouK2SB30xAvJ8tE584+j
qQ6CGecU9XjvlAjuJdCrDeVPsjkn7OPXG+8XZU7zqHZNmXX1YY4H5rgEJ48lrUrP
3I8R
-----END CERTIFICATE-----
</pre>

**3. Create JWS to Attach to Bundle**

**3.1. Prepare Header**

 note the base64 DER is Cert PEM file wihout the footer and header and line returns


```python
with open('cert.pem') as f:
    der = (f.read())  # base64 DER is PEM wihout the footer and header and line returns
der = der.replace('-----BEGIN CERTIFICATE-----','')
der = der.replace('-----END CERTIFICATE-----','')
der = der.replace('\n','')
```


```python
header = {"alg": "RS256","kty": "RS", "x5c": [der]}
header
```




<pre style="border:0; overflow-wrap:break-word;">
{'alg': 'RS256',
 'kty': 'RS',
 'x5c': ['MIIE3zCCA0egAwIBAgIJAOKFYvMwR+yQMA0GCSqGSIb3DQEBCwUAMIGNMQswCQYDVQQGEwJVUzETMBEGA1UECAwKQ2FsaWZvcm5pYTESMBAGA1UEBwwJU2F1c2FsaXRvMRUwEwYDVQQKDAxIZWFsdGhlRGF0YTExFzAVBgNVBAMMDkVyaWMgSGFhcywgRFZNMSUwIwYJKoZIhvcNAQkBFhZlaGFhc0BoZWFsdGhlZGF0YTEub3JnMB4XDTIxMTAyNzE3NDIwNFoXDTIyMTAyMjE3NDIwNFowgY0xCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApDYWxpZm9ybmlhMRIwEAYDVQQHDAlTYXVzYWxpdG8xFTATBgNVBAoMDEhlYWx0aGVEYXRhMTEXMBUGA1UEAwwORXJpYyBIYWFzLCBEVk0xJTAjBgkqhkiG9w0BCQEWFmVoYWFzQGhlYWx0aGVkYXRhMS5vcmcwggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAwggGKAoIBgQDpKcSkoAM6sW21+vWTeIVOGx10MWasQy7VHid6zyqXABM+znfBnXenyU0j1FTvPmRfODoODXVuPUwDomhCHh+bclW9KM2o563cxRKEvBnaHrsjw5yNmxO5YjERbhtHdQeqktdw3VYERR9HoxLO3FkszR292HTB4xW3yWlV3gTkMQozPScJKH3bG8Pqq6AYPJ7C4YBIlUSdBMVl3qneEfg7fuxiFfXofdTVm7rMiiG7X9z43PfilqaeisfmtRxAlRwENXrH3OvODPyL0rTnG8CsbAXYVIMmddHe4ZF9plh95sj4pMThLtcJX/o9XHLjh7EmZygJHWEQq4PwFwZdmbcfhCmOr88H8BbUru/7V6zbsG1N1CWlndlbVznL+3IMOr8kXaHcanqfckgFV4ErnfjFJq1OIaAmsMj85xMkjyXLycLL/u5n2o6Bg93/URfquOoSIGOCR25DaZzpw2k3s7oE9dMwEWXtfXgYth2bljy5tFH0GjpOkx07j7ZT5HnxnlsCAwEAAaNAMD4wDAYDVR0TBAUwAwEB/zALBgNVHQ8EBAMCBeAwIQYDVR0RBBowGIIWd3d3LmhlYWx0aGVkYXRhaW5jLmNvbTANBgkqhkiG9w0BAQsFAAOCAYEACuMUNq9ay++e5YC7QFO94rfzxGQnF3GklZNAXmIr7PVGdiGY2GTx/9RtHCwTKzkL+yvKojeZ9dVK8wrGViRkO/jUyZ+KcWRokUjs59ncJGRMSSRxteCQujt4hf2+/qV+f2sMQtErwPE30vbqRYUNNNBVEQpaQx/acJDUv9v7sjHiJDqXwQ+rzj95iHAIaeEHqF/Ms22p2beZuqvIQKeMl+svVqHtiuzWnF4U6VImpkr4bHl7egV9H6l6T2SMkj6qDU5e9Ng0ZlLTtosshBLmopF7e7HyrTEAmfOPKQe0Eg9E2urzxqBuG54k50G2J0FiPsQJAhFiNGwSg4S3HyVDG7ueKd0L93wKONOYGvMKizCHB+pKvEMJoZ8y9uiB+HFXcp9RaJqJ97HpZTEv+liCp2PSXzcK0r25ScyjF6dLouK2SB30xAvJ8tE584+jqQ6CGecU9XjvlAjuJdCrDeVPsjkn7OPXG+8XZU7zqHZNmXX1YY4H5rgEJ48lrUrP3I8R']}
</pre>


**3.2. Prepare Payload**

The payload is the base64_url form of the canonicalized version of the document Bundle before attaching the signature


 Canonicalize the bundle using IETF JSON Canonicalization Scheme (JCS) before adding the signature element:

- Remove the id and meta elements if present before canonicalization
- The base64_url of the payload entry is combined with 3.3 below using the jws.sign method.


```python
from jcs import canonicalize #package for a JCS (RFC 8785) compliant canonicalizer.
from json import loads
document_bundle = r'''{
  "resourceType": "Bundle",
  "id": "cdex-document-digital-sig-example",
  "meta": {
    "extension": [
      {
        "url": "http://hl7.org/fhir/StructureDefinition/instance-name",
        "valueString": "CDEX Document with Digital Signature Example"
      },
      {
        "url": "http://hl7.org/fhir/StructureDefinition/instance-description",
        "valueMarkdown": "Digital signature example showing how it is used to sign a FHIR Document.  The CDEX use case would be the target resource in response to a Task-based request where an digital signature was required.  If no signature was required, the response would typically be in the form of an individual resource."
      }
    ]
  },
  "identifier": {
    "system": "urn:ietf:rfc:3986",
    "value": "urn:uuid:c173535e-135e-48e3-ab64-38bacc68dba8"
  },
  "type": "document",
  "timestamp": "2021-10-25T20:16:29-07:00",
  "entry": [
    {
      "fullUrl": "urn:uuid:17a80a8d-4cf1-4deb-a1fd-2db1130e5f76",
      "resource": {
        "resourceType": "Composition",
        "id": "17a80a8d-4cf1-4deb-a1fd-2db1130e5f76",
        "text": {
          "status": "generated",
          "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource \"17a80a8d-4cf1-4deb-a1fd-2db1130e5f76\" </p></div><p><b>status</b>: final</p><p><b>type</b>: Medical records <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://loinc.org/\">LOINC</a>#11503-0)</span></p><p><b>encounter</b>: <a href=\"#Encounter_5ce5c83a-000f-47d2-941c-039358cc9112\">See above (urn:uuid:5ce5c83a-000f-47d2-941c-039358cc9112: Example Encounter)</a></p><p><b>date</b>: 2021-10-25T20:16:29-07:00</p><p><b>author</b>: <a href=\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\">See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: Example Practitioner)</a></p><p><b>title</b>: Active Conditions</p><h3>Attesters</h3><table class=\"grid\"><tr><td>-</td><td><b>Mode</b></td><td><b>Time</b></td><td><b>Party</b></td></tr><tr><td>*</td><td>legal</td><td>2021-10-25T20:16:29-07:00</td><td><a href=\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\">See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: Example Practitioner)</a></td></tr></table></div>"
        },
        "status": "final",
        "type": {
          "coding": [
            {
              "system": "http://loinc.org",
              "code": "11503-0"
            }
          ],
          "text": "Medical records"
        },
        "subject": {
          "reference": "urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece",
          "display": "Example Patient"
        },
        "encounter": {
          "reference": "urn:uuid:5ce5c83a-000f-47d2-941c-039358cc9112",
          "display": "Example Encounter"
        },
        "date": "2021-10-25T20:16:29-07:00",
        "author": [
          {
            "reference": "urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc",
            "display": "Example Practitioner"
          }
        ],
        "title": "Active Conditions",
        "attester": [
          {
            "mode": "legal",
            "time": "2021-10-25T20:16:29-07:00",
            "party": {
              "reference": "urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc",
              "display": "Example Practitioner"
            }
          }
        ],
        "section": [
          {
            "title": "Active Condition 1",
            "entry": [
              {
                "reference": "urn:uuid:014a68ec-d691-49e0-b980-91b0d924e570"
              }
            ]
          }
        ]
      }
    },
    {
      "fullUrl": "urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc",
      "resource": {
        "resourceType": "Practitioner",
        "id": "0820c16d-91de-4dfa-a3a6-f140a516a9bc",
        "meta": {
          "lastUpdated": "2013-05-05T16:13:03Z"
        },
        "text": {
          "status": "generated",
          "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource \"0820c16d-91de-4dfa-a3a6-f140a516a9bc\" Updated \"2013-05-05T16:13:03Z\" </p></div><p><b>name</b>: John Hancock </p></div>"
        },
        "name": [
          {
            "family": "Hancock",
            "given": [
              "John"
            ]
          }
        ]
      }
    },
    {
      "fullUrl": "urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece",
      "resource": {
        "resourceType": "Patient",
        "id": "970af6c9-5bbd-4067-b6c1-d9b2c823aece",
        "text": {
          "status": "generated",
          "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource \"970af6c9-5bbd-4067-b6c1-d9b2c823aece\" </p></div><p><b>active</b>: true</p><p><b>name</b>: CDEX Example Patient</p></div>"
        },
        "active": true,
        "name": [
          {
            "text": "CDEX Example Patient",
            "family": "Patient",
            "given": [
              "CDEX Example"
            ]
          }
        ]
      }
    },
    {
      "fullUrl": "urn:uuid:014a68ec-d691-49e0-b980-91b0d924e570",
      "resource": {
        "resourceType": "Condition",
        "id": "014a68ec-d691-49e0-b980-91b0d924e570",
        "text": {
          "status": "generated",
          "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource \"014a68ec-d691-49e0-b980-91b0d924e570\" </p></div><p><b>identifier</b>: id: 1</p><p><b>clinicalStatus</b>: Active <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/3.0.0/CodeSystem-condition-clinical.html\">Condition Clinical Status Codes</a>#active)</span></p><p><b>category</b>: Problem <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://browser.ihtsdotools.org/\">SNOMED CT</a>#55607006; <a href=\"https://loinc.org/\">LOINC</a>#75326-9)</span></p><p><b>code</b>: Type 2 Diabetes Mellitus <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://browser.ihtsdotools.org/\">SNOMED CT</a>#44054006)</span></p><p><b>subject</b>: <a href=\"#Patient_970af6c9-5bbd-4067-b6c1-d9b2c823aece\">See above (urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece)</a></p><p><b>onset</b>: 2006-01-01</p><p><b>asserter</b>: <a href=\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\">See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc)</a></p></div>"
        },
        "identifier": [
          {
            "system": "urn:oid:1.3.6.1.4.1.22812.4.111.0.4.1.2.1",
            "value": "1"
          }
        ],
        "clinicalStatus": {
          "coding": [
            {
              "system": "http://terminology.hl7.org/CodeSystem/condition-clinical",
              "code": "active"
            }
          ]
        },
        "category": [
          {
            "coding": [
              {
                "system": "http://snomed.info/sct",
                "code": "55607006",
                "display": "Problem"
              },
              {
                "system": "http://loinc.org",
                "code": "75326-9",
                "display": "Problem"
              }
            ]
          }
        ],
        "code": {
          "coding": [
            {
              "system": "http://snomed.info/sct",
              "code": "44054006",
              "display": "Type 2 Diabetes Mellitus"
            }
          ]
        },
        "subject": {
          "reference": "urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece"
        },
        "onsetDateTime": "2006",
        "asserter": {
          "reference": "urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"
        }
      }
    },
    {
      "fullUrl": "urn:uuid:5ce5c83a-000f-47d2-941c-039358cc9112",
      "resource": {
        "resourceType": "Encounter",
        "id": "5ce5c83a-000f-47d2-941c-039358cc9112",
        "text": {
          "status": "generated",
          "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource \"5ce5c83a-000f-47d2-941c-039358cc9112\" </p></div><p><b>status</b>: finished</p><p><b>class</b>: emergency (Details: http://terminology.hl7.org/CodeSystem/v3-ActCode code EMER = 'emergency', stated as 'null')</p><p><b>type</b>: Unknown (qualifier value) <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://browser.ihtsdotools.org/\">SNOMED CT</a>#261665006)</span></p><p><b>subject</b>: <a href=\"#Patient_970af6c9-5bbd-4067-b6c1-d9b2c823aece\">See above (urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece: CDEX Example Patient)</a></p><h3>Participants</h3><table class=\"grid\"><tr><td>-</td><td><b>Individual</b></td></tr><tr><td>*</td><td><a href=\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\">See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: John Hancock)</a></td></tr></table><p><b>period</b>: 2021-10-25T20:10:29-07:00 --&gt; 2021-10-25T20:16:29-07:00</p><p><b>serviceProvider</b>: <a href=\"#Organization_e37f004b-dc10-422b-b833-cdaa10a055a3\">See above (urn:uuid:e37f004b-dc10-422b-b833-cdaa10a055a3: CDEX Example Organization)</a></p></div>"
        },
        "status": "finished",
        "class": {
          "system": "http://terminology.hl7.org/CodeSystem/v3-ActCode",
          "code": "EMER"
        },
        "type": [
          {
            "coding": [
              {
                "system": "http://snomed.info/sct",
                "code": "261665006",
                "display": "Unknown (qualifier value)"
              }
            ],
            "text": "Unknown (qualifier value)"
          }
        ],
        "subject": {
          "reference": "urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece",
          "display": "CDEX Example Patient"
        },
        "participant": [
          {
            "individual": {
              "reference": "urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc",
              "display": "John Hancock"
            }
          }
        ],
        "period": {
          "start": "2021-10-25T20:10:29-07:00",
          "end": "2021-10-25T20:16:29-07:00"
        },
        "serviceProvider": {
          "reference": "urn:uuid:e37f004b-dc10-422b-b833-cdaa10a055a3",
          "display": "CDEX Example Organization"
        }
      }
    },
    {
      "fullUrl": "urn:uuid:e37f004b-dc10-422b-b833-cdaa10a055a3",
      "resource": {
        "resourceType": "Organization",
        "id": "e37f004b-dc10-422b-b833-cdaa10a055a3",
        "text": {
          "status": "generated",
          "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource \"e37f004b-dc10-422b-b833-cdaa10a055a3\" </p></div><p><b>active</b>: true</p><p><b>name</b>: CDEX Example Organization</p><p><b>telecom</b>: ph: (+1) 555-555-5555, <a href=\"mailto:customer-service@example.org\">customer-service@example.org</a></p><p><b>address</b>: 1 CDEX Lane Boston MA 01002 USA </p></div>"
        },
        "active": true,
        "name": "CDEX Example Organization",
        "telecom": [
          {
            "system": "phone",
            "value": "(+1) 555-555-5555"
          },
          {
            "system": "email",
            "value": "customer-service@example.org"
          }
        ],
        "address": [
          {
            "line": [
              "1 CDEX Lane"
            ],
            "city": "Boston",
            "state": "MA",
            "postalCode": "01002",
            "country": "USA"
          }
        ]
      }
    }
  ]
}'''
document_bundle = loads(document_bundle) #convert to Python object
document_bundle_id = document_bundle.pop("id") # remove id
document_bundle_meta = document_bundle.pop("meta") # remove meta
payload = canonicalize(document_bundle)
payload
```

<pre style="border:0; overflow-wrap:break-word;">
b'{"entry":[{"fullUrl":"urn:uuid:17a80a8d-4cf1-4deb-a1fd-2db1130e5f76","resource":{"attester":[{"mode":"legal","party":{"display":"Example Practitioner","reference":"urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"},"time":"2021-10-25T20:16:29-07:00"}],"author":[{"display":"Example Practitioner","reference":"urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"}],"date":"2021-10-25T20:16:29-07:00","encounter":{"display":"Example Encounter","reference":"urn:uuid:5ce5c83a-000f-47d2-941c-039358cc9112"},"id":"17a80a8d-4cf1-4deb-a1fd-2db1130e5f76","resourceType":"Composition","section":[{"entry":[{"reference":"urn:uuid:014a68ec-d691-49e0-b980-91b0d924e570"}],"title":"Active Condition 1"}],"status":"final","subject":{"display":"Example Patient","reference":"urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece"},"text":{"div":"&lt;div xmlns=\\"http://www.w3.org/1999/xhtml\\"&gt;&lt;p&gt;&lt;b&gt;Generated Narrative&lt;/b&gt;&lt;/p&gt;&lt;div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"&gt;&lt;p style=\\"margin-bottom: 0px\\"&gt;Resource \\"17a80a8d-4cf1-4deb-a1fd-2db1130e5f76\\" &lt;/p&gt;&lt;/div&gt;&lt;p&gt;&lt;b&gt;status&lt;/b&gt;: final&lt;/p&gt;&lt;p&gt;&lt;b&gt;type&lt;/b&gt;: Medical records &lt;span style=\\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\\"&gt; (&lt;a href=\\"https://loinc.org/\\"&gt;LOINC&lt;/a&gt;#11503-0)&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;encounter&lt;/b&gt;: &lt;a href=\\"#Encounter_5ce5c83a-000f-47d2-941c-039358cc9112\\"&gt;See above (urn:uuid:5ce5c83a-000f-47d2-941c-039358cc9112: Example Encounter)&lt;/a&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;date&lt;/b&gt;: 2021-10-25T20:16:29-07:00&lt;/p&gt;&lt;p&gt;&lt;b&gt;author&lt;/b&gt;: &lt;a href=\\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\\"&gt;See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: Example Practitioner)&lt;/a&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;title&lt;/b&gt;: Active Conditions&lt;/p&gt;&lt;h3&gt;Attesters&lt;/h3&gt;&lt;table class=\\"grid\\"&gt;&lt;tr&gt;&lt;td&gt;-&lt;/td&gt;&lt;td&gt;&lt;b&gt;Mode&lt;/b&gt;&lt;/td&gt;&lt;td&gt;&lt;b&gt;Time&lt;/b&gt;&lt;/td&gt;&lt;td&gt;&lt;b&gt;Party&lt;/b&gt;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;*&lt;/td&gt;&lt;td&gt;legal&lt;/td&gt;&lt;td&gt;2021-10-25T20:16:29-07:00&lt;/td&gt;&lt;td&gt;&lt;a href=\\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\\"&gt;See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: Example Practitioner)&lt;/a&gt;&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;/div&gt;","status":"generated"},"title":"Active Conditions","type":{"coding":[{"code":"11503-0","system":"http://loinc.org"}],"text":"Medical records"}}},{"fullUrl":"urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc","resource":{"id":"0820c16d-91de-4dfa-a3a6-f140a516a9bc","meta":{"lastUpdated":"2013-05-05T16:13:03Z"},"name":[{"family":"Hancock","given":["John"]}],"resourceType":"Practitioner","text":{"div":"&lt;div xmlns=\\"http://www.w3.org/1999/xhtml\\"&gt;&lt;p&gt;&lt;b&gt;Generated Narrative&lt;/b&gt;&lt;/p&gt;&lt;div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"&gt;&lt;p style=\\"margin-bottom: 0px\\"&gt;Resource \\"0820c16d-91de-4dfa-a3a6-f140a516a9bc\\" Updated \\"2013-05-05T16:13:03Z\\" &lt;/p&gt;&lt;/div&gt;&lt;p&gt;&lt;b&gt;name&lt;/b&gt;: John Hancock &lt;/p&gt;&lt;/div&gt;","status":"generated"}}},{"fullUrl":"urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece","resource":{"active":true,"id":"970af6c9-5bbd-4067-b6c1-d9b2c823aece","name":[{"family":"Patient","given":["CDEX Example"],"text":"CDEX Example Patient"}],"resourceType":"Patient","text":{"div":"&lt;div xmlns=\\"http://www.w3.org/1999/xhtml\\"&gt;&lt;p&gt;&lt;b&gt;Generated Narrative&lt;/b&gt;&lt;/p&gt;&lt;div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"&gt;&lt;p style=\\"margin-bottom: 0px\\"&gt;Resource \\"970af6c9-5bbd-4067-b6c1-d9b2c823aece\\" &lt;/p&gt;&lt;/div&gt;&lt;p&gt;&lt;b&gt;active&lt;/b&gt;: true&lt;/p&gt;&lt;p&gt;&lt;b&gt;name&lt;/b&gt;: CDEX Example Patient&lt;/p&gt;&lt;/div&gt;","status":"generated"}}},{"fullUrl":"urn:uuid:014a68ec-d691-49e0-b980-91b0d924e570","resource":{"asserter":{"reference":"urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"},"category":[{"coding":[{"code":"55607006","display":"Problem","system":"http://snomed.info/sct"},{"code":"75326-9","display":"Problem","system":"http://loinc.org"}]}],"clinicalStatus":{"coding":[{"code":"active","system":"http://terminology.hl7.org/CodeSystem/condition-clinical"}]},"code":{"coding":[{"code":"44054006","display":"Type 2 Diabetes Mellitus","system":"http://snomed.info/sct"}]},"id":"014a68ec-d691-49e0-b980-91b0d924e570","identifier":[{"system":"urn:oid:1.3.6.1.4.1.22812.4.111.0.4.1.2.1","value":"1"}],"onsetDateTime":"2006","resourceType":"Condition","subject":{"reference":"urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece"},"text":{"div":"&lt;div xmlns=\\"http://www.w3.org/1999/xhtml\\"&gt;&lt;p&gt;&lt;b&gt;Generated Narrative&lt;/b&gt;&lt;/p&gt;&lt;div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"&gt;&lt;p style=\\"margin-bottom: 0px\\"&gt;Resource \\"014a68ec-d691-49e0-b980-91b0d924e570\\" &lt;/p&gt;&lt;/div&gt;&lt;p&gt;&lt;b&gt;identifier&lt;/b&gt;: id: 1&lt;/p&gt;&lt;p&gt;&lt;b&gt;clinicalStatus&lt;/b&gt;: Active &lt;span style=\\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\\"&gt; (&lt;a href=\\"http://terminology.hl7.org/3.0.0/CodeSystem-condition-clinical.html\\"&gt;Condition Clinical Status Codes&lt;/a&gt;#active)&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;category&lt;/b&gt;: Problem &lt;span style=\\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\\"&gt; (&lt;a href=\\"https://browser.ihtsdotools.org/\\"&gt;SNOMED CT&lt;/a&gt;#55607006; &lt;a href=\\"https://loinc.org/\\"&gt;LOINC&lt;/a&gt;#75326-9)&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;code&lt;/b&gt;: Type 2 Diabetes Mellitus &lt;span style=\\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\\"&gt; (&lt;a href=\\"https://browser.ihtsdotools.org/\\"&gt;SNOMED CT&lt;/a&gt;#44054006)&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;subject&lt;/b&gt;: &lt;a href=\\"#Patient_970af6c9-5bbd-4067-b6c1-d9b2c823aece\\"&gt;See above (urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece)&lt;/a&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;onset&lt;/b&gt;: 2006-01-01&lt;/p&gt;&lt;p&gt;&lt;b&gt;asserter&lt;/b&gt;: &lt;a href=\\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\\"&gt;See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc)&lt;/a&gt;&lt;/p&gt;&lt;/div&gt;","status":"generated"}}},{"fullUrl":"urn:uuid:5ce5c83a-000f-47d2-941c-039358cc9112","resource":{"class":{"code":"EMER","system":"http://terminology.hl7.org/CodeSystem/v3-ActCode"},"id":"5ce5c83a-000f-47d2-941c-039358cc9112","participant":[{"individual":{"display":"John Hancock","reference":"urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"}}],"period":{"end":"2021-10-25T20:16:29-07:00","start":"2021-10-25T20:10:29-07:00"},"resourceType":"Encounter","serviceProvider":{"display":"CDEX Example Organization","reference":"urn:uuid:e37f004b-dc10-422b-b833-cdaa10a055a3"},"status":"finished","subject":{"display":"CDEX Example Patient","reference":"urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece"},"text":{"div":"&lt;div xmlns=\\"http://www.w3.org/1999/xhtml\\"&gt;&lt;p&gt;&lt;b&gt;Generated Narrative&lt;/b&gt;&lt;/p&gt;&lt;div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"&gt;&lt;p style=\\"margin-bottom: 0px\\"&gt;Resource \\"5ce5c83a-000f-47d2-941c-039358cc9112\\" &lt;/p&gt;&lt;/div&gt;&lt;p&gt;&lt;b&gt;status&lt;/b&gt;: finished&lt;/p&gt;&lt;p&gt;&lt;b&gt;class&lt;/b&gt;: emergency (Details: http://terminology.hl7.org/CodeSystem/v3-ActCode code EMER = \'emergency\', stated as \'null\')&lt;/p&gt;&lt;p&gt;&lt;b&gt;type&lt;/b&gt;: Unknown (qualifier value) &lt;span style=\\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\\"&gt; (&lt;a href=\\"https://browser.ihtsdotools.org/\\"&gt;SNOMED CT&lt;/a&gt;#261665006)&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;subject&lt;/b&gt;: &lt;a href=\\"#Patient_970af6c9-5bbd-4067-b6c1-d9b2c823aece\\"&gt;See above (urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece: CDEX Example Patient)&lt;/a&gt;&lt;/p&gt;&lt;h3&gt;Participants&lt;/h3&gt;&lt;table class=\\"grid\\"&gt;&lt;tr&gt;&lt;td&gt;-&lt;/td&gt;&lt;td&gt;&lt;b&gt;Individual&lt;/b&gt;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;*&lt;/td&gt;&lt;td&gt;&lt;a href=\\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\\"&gt;See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: John Hancock)&lt;/a&gt;&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;p&gt;&lt;b&gt;period&lt;/b&gt;: 2021-10-25T20:10:29-07:00 --&gt; 2021-10-25T20:16:29-07:00&lt;/p&gt;&lt;p&gt;&lt;b&gt;serviceProvider&lt;/b&gt;: &lt;a href=\\"#Organization_e37f004b-dc10-422b-b833-cdaa10a055a3\\"&gt;See above (urn:uuid:e37f004b-dc10-422b-b833-cdaa10a055a3: CDEX Example Organization)&lt;/a&gt;&lt;/p&gt;&lt;/div&gt;","status":"generated"},"type":[{"coding":[{"code":"261665006","display":"Unknown (qualifier value)","system":"http://snomed.info/sct"}],"text":"Unknown (qualifier value)"}]}},{"fullUrl":"urn:uuid:e37f004b-dc10-422b-b833-cdaa10a055a3","resource":{"active":true,"address":[{"city":"Boston","country":"USA","line":["1 CDEX Lane"],"postalCode":"01002","state":"MA"}],"id":"e37f004b-dc10-422b-b833-cdaa10a055a3","name":"CDEX Example Organization","resourceType":"Organization","telecom":[{"system":"phone","value":"(+1) 555-555-5555"},{"system":"email","value":"customer-service@example.org"}],"text":{"div":"&lt;div xmlns=\\"http://www.w3.org/1999/xhtml\\"&gt;&lt;p&gt;&lt;b&gt;Generated Narrative&lt;/b&gt;&lt;/p&gt;&lt;div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"&gt;&lt;p style=\\"margin-bottom: 0px\\"&gt;Resource \\"e37f004b-dc10-422b-b833-cdaa10a055a3\\" &lt;/p&gt;&lt;/div&gt;&lt;p&gt;&lt;b&gt;active&lt;/b&gt;: true&lt;/p&gt;&lt;p&gt;&lt;b&gt;name&lt;/b&gt;: CDEX Example Organization&lt;/p&gt;&lt;p&gt;&lt;b&gt;telecom&lt;/b&gt;: ph: (+1) 555-555-5555, &lt;a href=\\"mailto:customer-service@example.org\\"&gt;customer-service@example.org&lt;/a&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;address&lt;/b&gt;: 1 CDEX Lane Boston MA 01002 USA &lt;/p&gt;&lt;/div&gt;","status":"generated"}}}],"identifier":{"system":"urn:ietf:rfc:3986","value":"urn:uuid:c173535e-135e-48e3-ab64-38bacc68dba8"},"resourceType":"Bundle","timestamp":"2021-10-25T20:16:29-07:00","type":"document"}'
</pre>



**3.3 Create Signature using private key and the RS256 algorithm to get the JWS compact serialization format**

note the signature is displayed with the parts labeled and separated with line breaks for easier viewing.


```python
from jose import jws
with open('private-key.pem') as f:
    private_key = (f.read())

signature = jws.sign(payload,private_key,algorithm='RS256',headers=header)

labels = ['header', 'payload', 'signature']
for i,j in enumerate(signature.split('.')):
    print(f'{labels[i]}:')
    print(f'{j}')
    print()
```

<pre style="border:0; overflow-wrap:break-word;">
header:
eyJhbGciOiJSUzI1NiIsImt0eSI6IlJTIiwidHlwIjoiSldUIiwieDVjIjpbIk1JSUUzekNDQTBlZ0F3SUJBZ0lKQU9LRll2TXdSK3lRTUEwR0NTcUdTSWIzRFFFQkN3VUFNSUdOTVFzd0NRWURWUVFHRXdKVlV6RVRNQkVHQTFVRUNBd0tRMkZzYVdadmNtNXBZVEVTTUJBR0ExVUVCd3dKVTJGMWMyRnNhWFJ2TVJVd0V3WURWUVFLREF4SVpXRnNkR2hsUkdGMFlURXhGekFWQmdOVkJBTU1Ea1Z5YVdNZ1NHRmhjeXdnUkZaTk1TVXdJd1lKS29aSWh2Y05BUWtCRmhabGFHRmhjMEJvWldGc2RHaGxaR0YwWVRFdWIzSm5NQjRYRFRJeE1UQXlOekUzTkRJd05Gb1hEVEl5TVRBeU1qRTNOREl3TkZvd2dZMHhDekFKQmdOVkJBWVRBbFZUTVJNd0VRWURWUVFJREFwRFlXeHBabTl5Ym1saE1SSXdFQVlEVlFRSERBbFRZWFZ6WVd4cGRHOHhGVEFUQmdOVkJBb01ERWhsWVd4MGFHVkVZWFJoTVRFWE1CVUdBMVVFQXd3T1JYSnBZeUJJWVdGekxDQkVWazB4SlRBakJna3Foa2lHOXcwQkNRRVdGbVZvWVdGelFHaGxZV3gwYUdWa1lYUmhNUzV2Y21jd2dnR2lNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUJqd0F3Z2dHS0FvSUJnUURwS2NTa29BTTZzVzIxK3ZXVGVJVk9HeDEwTVdhc1F5N1ZIaWQ2enlxWEFCTSt6bmZCblhlbnlVMGoxRlR2UG1SZk9Eb09EWFZ1UFV3RG9taENIaCtiY2xXOUtNMm81NjNjeFJLRXZCbmFIcnNqdzV5Tm14TzVZakVSYmh0SGRRZXFrdGR3M1ZZRVJSOUhveExPM0Zrc3pSMjkySFRCNHhXM3lXbFYzZ1RrTVFvelBTY0pLSDNiRzhQcXE2QVlQSjdDNFlCSWxVU2RCTVZsM3FuZUVmZzdmdXhpRmZYb2ZkVFZtN3JNaWlHN1g5ejQzUGZpbHFhZWlzZm10UnhBbFJ3RU5YckgzT3ZPRFB5TDByVG5HOENzYkFYWVZJTW1kZEhlNFpGOXBsaDk1c2o0cE1UaEx0Y0pYL285WEhMamg3RW1aeWdKSFdFUXE0UHdGd1pkbWJjZmhDbU9yODhIOEJiVXJ1LzdWNnpic0cxTjFDV2xuZGxiVnpuTCszSU1PcjhrWGFIY2FucWZja2dGVjRFcm5makZKcTFPSWFBbXNNajg1eE1ranlYTHljTEwvdTVuMm82Qmc5My9VUmZxdU9vU0lHT0NSMjVEYVp6cHcyazNzN29FOWRNd0VXWHRmWGdZdGgyYmxqeTV0RkgwR2pwT2t4MDdqN1pUNUhueG5sc0NBd0VBQWFOQU1ENHdEQVlEVlIwVEJBVXdBd0VCL3pBTEJnTlZIUThFQkFNQ0JlQXdJUVlEVlIwUkJCb3dHSUlXZDNkM0xtaGxZV3gwYUdWa1lYUmhhVzVqTG1OdmJUQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FZRUFDdU1VTnE5YXkrK2U1WUM3UUZPOTRyZnp4R1FuRjNHa2xaTkFYbUlyN1BWR2RpR1kyR1R4LzlSdEhDd1RLemtMK3l2S29qZVo5ZFZLOHdyR1ZpUmtPL2pVeVorS2NXUm9rVWpzNTluY0pHUk1TU1J4dGVDUXVqdDRoZjIrL3FWK2Yyc01RdEVyd1BFMzB2YnFSWVVOTk5CVkVRcGFReC9hY0pEVXY5djdzakhpSkRxWHdRK3J6ajk1aUhBSWFlRUhxRi9NczIycDJiZVp1cXZJUUtlTWwrc3ZWcUh0aXV6V25GNFU2VkltcGtyNGJIbDdlZ1Y5SDZsNlQyU01rajZxRFU1ZTlOZzBabExUdG9zc2hCTG1vcEY3ZTdIeXJURUFtZk9QS1FlMEVnOUUydXJ6eHFCdUc1NGs1MEcySjBGaVBzUUpBaEZpTkd3U2c0UzNIeVZERzd1ZUtkMEw5M3dLT05PWUd2TUtpekNIQitwS3ZFTUpvWjh5OXVpQitIRlhjcDlSYUpxSjk3SHBaVEV2K2xpQ3AyUFNYemNLMHIyNVNjeWpGNmRMb3VLMlNCMzB4QXZKOHRFNTg0K2pxUTZDR2VjVTlYanZsQWp1SmRDckRlVlBzamtuN09QWEcrOFhaVTd6cUhaTm1YWDFZWTRINXJnRUo0OGxyVXJQM0k4UiJdfQ

payload:
eyJlbnRyeSI6W3siZnVsbFVybCI6InVybjp1dWlkOjE3YTgwYThkLTRjZjEtNGRlYi1hMWZkLTJkYjExMzBlNWY3NiIsInJlc291cmNlIjp7ImF0dGVzdGVyIjpbeyJtb2RlIjoibGVnYWwiLCJwYXJ0eSI6eyJkaXNwbGF5IjoiRXhhbXBsZSBQcmFjdGl0aW9uZXIiLCJyZWZlcmVuY2UiOiJ1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMifSwidGltZSI6IjIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDAifV0sImF1dGhvciI6W3siZGlzcGxheSI6IkV4YW1wbGUgUHJhY3RpdGlvbmVyIiwicmVmZXJlbmNlIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIn1dLCJkYXRlIjoiMjAyMS0xMC0yNVQyMDoxNjoyOS0wNzowMCIsImVuY291bnRlciI6eyJkaXNwbGF5IjoiRXhhbXBsZSBFbmNvdW50ZXIiLCJyZWZlcmVuY2UiOiJ1cm46dXVpZDo1Y2U1YzgzYS0wMDBmLTQ3ZDItOTQxYy0wMzkzNThjYzkxMTIifSwiaWQiOiIxN2E4MGE4ZC00Y2YxLTRkZWItYTFmZC0yZGIxMTMwZTVmNzYiLCJyZXNvdXJjZVR5cGUiOiJDb21wb3NpdGlvbiIsInNlY3Rpb24iOlt7ImVudHJ5IjpbeyJyZWZlcmVuY2UiOiJ1cm46dXVpZDowMTRhNjhlYy1kNjkxLTQ5ZTAtYjk4MC05MWIwZDkyNGU1NzAifV0sInRpdGxlIjoiQWN0aXZlIENvbmRpdGlvbiAxIn1dLCJzdGF0dXMiOiJmaW5hbCIsInN1YmplY3QiOnsiZGlzcGxheSI6IkV4YW1wbGUgUGF0aWVudCIsInJlZmVyZW5jZSI6InVybjp1dWlkOjk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZSJ9LCJ0ZXh0Ijp7ImRpdiI6IjxkaXYgeG1sbnM9XCJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hodG1sXCI-PHA-PGI-R2VuZXJhdGVkIE5hcnJhdGl2ZTwvYj48L3A-PGRpdiBzdHlsZT1cImRpc3BsYXk6IGlubGluZS1ibG9jazsgYmFja2dyb3VuZC1jb2xvcjogI2Q5ZTBlNzsgcGFkZGluZzogNnB4OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQgIzhkYTFiNDsgYm9yZGVyLXJhZGl1czogNXB4OyBsaW5lLWhlaWdodDogNjAlXCI-PHAgc3R5bGU9XCJtYXJnaW4tYm90dG9tOiAwcHhcIj5SZXNvdXJjZSBcIjE3YTgwYThkLTRjZjEtNGRlYi1hMWZkLTJkYjExMzBlNWY3NlwiIDwvcD48L2Rpdj48cD48Yj5zdGF0dXM8L2I-OiBmaW5hbDwvcD48cD48Yj50eXBlPC9iPjogTWVkaWNhbCByZWNvcmRzIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vbG9pbmMub3JnL1wiPkxPSU5DPC9hPiMxMTUwMy0wKTwvc3Bhbj48L3A-PHA-PGI-ZW5jb3VudGVyPC9iPjogPGEgaHJlZj1cIiNFbmNvdW50ZXJfNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyXCI-U2VlIGFib3ZlICh1cm46dXVpZDo1Y2U1YzgzYS0wMDBmLTQ3ZDItOTQxYy0wMzkzNThjYzkxMTI6IEV4YW1wbGUgRW5jb3VudGVyKTwvYT48L3A-PHA-PGI-ZGF0ZTwvYj46IDIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDA8L3A-PHA-PGI-YXV0aG9yPC9iPjogPGEgaHJlZj1cIiNQcmFjdGl0aW9uZXJfMDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjXCI-U2VlIGFib3ZlICh1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmM6IEV4YW1wbGUgUHJhY3RpdGlvbmVyKTwvYT48L3A-PHA-PGI-dGl0bGU8L2I-OiBBY3RpdmUgQ29uZGl0aW9uczwvcD48aDM-QXR0ZXN0ZXJzPC9oMz48dGFibGUgY2xhc3M9XCJncmlkXCI-PHRyPjx0ZD4tPC90ZD48dGQ-PGI-TW9kZTwvYj48L3RkPjx0ZD48Yj5UaW1lPC9iPjwvdGQ-PHRkPjxiPlBhcnR5PC9iPjwvdGQ-PC90cj48dHI-PHRkPio8L3RkPjx0ZD5sZWdhbDwvdGQ-PHRkPjIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDA8L3RkPjx0ZD48YSBocmVmPVwiI1ByYWN0aXRpb25lcl8wODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmNcIj5TZWUgYWJvdmUgKHVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYzogRXhhbXBsZSBQcmFjdGl0aW9uZXIpPC9hPjwvdGQ-PC90cj48L3RhYmxlPjwvZGl2PiIsInN0YXR1cyI6ImdlbmVyYXRlZCJ9LCJ0aXRsZSI6IkFjdGl2ZSBDb25kaXRpb25zIiwidHlwZSI6eyJjb2RpbmciOlt7ImNvZGUiOiIxMTUwMy0wIiwic3lzdGVtIjoiaHR0cDovL2xvaW5jLm9yZyJ9XSwidGV4dCI6Ik1lZGljYWwgcmVjb3JkcyJ9fX0seyJmdWxsVXJsIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIiwicmVzb3VyY2UiOnsiaWQiOiIwODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMiLCJtZXRhIjp7Imxhc3RVcGRhdGVkIjoiMjAxMy0wNS0wNVQxNjoxMzowM1oifSwibmFtZSI6W3siZmFtaWx5IjoiSGFuY29jayIsImdpdmVuIjpbIkpvaG4iXX1dLCJyZXNvdXJjZVR5cGUiOiJQcmFjdGl0aW9uZXIiLCJ0ZXh0Ijp7ImRpdiI6IjxkaXYgeG1sbnM9XCJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hodG1sXCI-PHA-PGI-R2VuZXJhdGVkIE5hcnJhdGl2ZTwvYj48L3A-PGRpdiBzdHlsZT1cImRpc3BsYXk6IGlubGluZS1ibG9jazsgYmFja2dyb3VuZC1jb2xvcjogI2Q5ZTBlNzsgcGFkZGluZzogNnB4OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQgIzhkYTFiNDsgYm9yZGVyLXJhZGl1czogNXB4OyBsaW5lLWhlaWdodDogNjAlXCI-PHAgc3R5bGU9XCJtYXJnaW4tYm90dG9tOiAwcHhcIj5SZXNvdXJjZSBcIjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliY1wiIFVwZGF0ZWQgXCIyMDEzLTA1LTA1VDE2OjEzOjAzWlwiIDwvcD48L2Rpdj48cD48Yj5uYW1lPC9iPjogSm9obiBIYW5jb2NrIDwvcD48L2Rpdj4iLCJzdGF0dXMiOiJnZW5lcmF0ZWQifX19LHsiZnVsbFVybCI6InVybjp1dWlkOjk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZSIsInJlc291cmNlIjp7ImFjdGl2ZSI6dHJ1ZSwiaWQiOiI5NzBhZjZjOS01YmJkLTQwNjctYjZjMS1kOWIyYzgyM2FlY2UiLCJuYW1lIjpbeyJmYW1pbHkiOiJQYXRpZW50IiwiZ2l2ZW4iOlsiQ0RFWCBFeGFtcGxlIl0sInRleHQiOiJDREVYIEV4YW1wbGUgUGF0aWVudCJ9XSwicmVzb3VyY2VUeXBlIjoiUGF0aWVudCIsInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiOTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlXCIgPC9wPjwvZGl2PjxwPjxiPmFjdGl2ZTwvYj46IHRydWU8L3A-PHA-PGI-bmFtZTwvYj46IENERVggRXhhbXBsZSBQYXRpZW50PC9wPjwvZGl2PiIsInN0YXR1cyI6ImdlbmVyYXRlZCJ9fX0seyJmdWxsVXJsIjoidXJuOnV1aWQ6MDE0YTY4ZWMtZDY5MS00OWUwLWI5ODAtOTFiMGQ5MjRlNTcwIiwicmVzb3VyY2UiOnsiYXNzZXJ0ZXIiOnsicmVmZXJlbmNlIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIn0sImNhdGVnb3J5IjpbeyJjb2RpbmciOlt7ImNvZGUiOiI1NTYwNzAwNiIsImRpc3BsYXkiOiJQcm9ibGVtIiwic3lzdGVtIjoiaHR0cDovL3Nub21lZC5pbmZvL3NjdCJ9LHsiY29kZSI6Ijc1MzI2LTkiLCJkaXNwbGF5IjoiUHJvYmxlbSIsInN5c3RlbSI6Imh0dHA6Ly9sb2luYy5vcmcifV19XSwiY2xpbmljYWxTdGF0dXMiOnsiY29kaW5nIjpbeyJjb2RlIjoiYWN0aXZlIiwic3lzdGVtIjoiaHR0cDovL3Rlcm1pbm9sb2d5LmhsNy5vcmcvQ29kZVN5c3RlbS9jb25kaXRpb24tY2xpbmljYWwifV19LCJjb2RlIjp7ImNvZGluZyI6W3siY29kZSI6IjQ0MDU0MDA2IiwiZGlzcGxheSI6IlR5cGUgMiBEaWFiZXRlcyBNZWxsaXR1cyIsInN5c3RlbSI6Imh0dHA6Ly9zbm9tZWQuaW5mby9zY3QifV19LCJpZCI6IjAxNGE2OGVjLWQ2OTEtNDllMC1iOTgwLTkxYjBkOTI0ZTU3MCIsImlkZW50aWZpZXIiOlt7InN5c3RlbSI6InVybjpvaWQ6MS4zLjYuMS40LjEuMjI4MTIuNC4xMTEuMC40LjEuMi4xIiwidmFsdWUiOiIxIn1dLCJvbnNldERhdGVUaW1lIjoiMjAwNiIsInJlc291cmNlVHlwZSI6IkNvbmRpdGlvbiIsInN1YmplY3QiOnsicmVmZXJlbmNlIjoidXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlIn0sInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiMDE0YTY4ZWMtZDY5MS00OWUwLWI5ODAtOTFiMGQ5MjRlNTcwXCIgPC9wPjwvZGl2PjxwPjxiPmlkZW50aWZpZXI8L2I-OiBpZDogMTwvcD48cD48Yj5jbGluaWNhbFN0YXR1czwvYj46IEFjdGl2ZSA8c3BhbiBzdHlsZT1cImJhY2tncm91bmQ6IExpZ2h0R29sZGVuUm9kWWVsbG93OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQga2hha2lcIj4gKDxhIGhyZWY9XCJodHRwOi8vdGVybWlub2xvZ3kuaGw3Lm9yZy8zLjAuMC9Db2RlU3lzdGVtLWNvbmRpdGlvbi1jbGluaWNhbC5odG1sXCI-Q29uZGl0aW9uIENsaW5pY2FsIFN0YXR1cyBDb2RlczwvYT4jYWN0aXZlKTwvc3Bhbj48L3A-PHA-PGI-Y2F0ZWdvcnk8L2I-OiBQcm9ibGVtIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vYnJvd3Nlci5paHRzZG90b29scy5vcmcvXCI-U05PTUVEIENUPC9hPiM1NTYwNzAwNjsgPGEgaHJlZj1cImh0dHBzOi8vbG9pbmMub3JnL1wiPkxPSU5DPC9hPiM3NTMyNi05KTwvc3Bhbj48L3A-PHA-PGI-Y29kZTwvYj46IFR5cGUgMiBEaWFiZXRlcyBNZWxsaXR1cyA8c3BhbiBzdHlsZT1cImJhY2tncm91bmQ6IExpZ2h0R29sZGVuUm9kWWVsbG93OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQga2hha2lcIj4gKDxhIGhyZWY9XCJodHRwczovL2Jyb3dzZXIuaWh0c2RvdG9vbHMub3JnL1wiPlNOT01FRCBDVDwvYT4jNDQwNTQwMDYpPC9zcGFuPjwvcD48cD48Yj5zdWJqZWN0PC9iPjogPGEgaHJlZj1cIiNQYXRpZW50Xzk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZVwiPlNlZSBhYm92ZSAodXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlKTwvYT48L3A-PHA-PGI-b25zZXQ8L2I-OiAyMDA2LTAxLTAxPC9wPjxwPjxiPmFzc2VydGVyPC9iPjogPGEgaHJlZj1cIiNQcmFjdGl0aW9uZXJfMDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjXCI-U2VlIGFib3ZlICh1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMpPC9hPjwvcD48L2Rpdj4iLCJzdGF0dXMiOiJnZW5lcmF0ZWQifX19LHsiZnVsbFVybCI6InVybjp1dWlkOjVjZTVjODNhLTAwMGYtNDdkMi05NDFjLTAzOTM1OGNjOTExMiIsInJlc291cmNlIjp7ImNsYXNzIjp7ImNvZGUiOiJFTUVSIiwic3lzdGVtIjoiaHR0cDovL3Rlcm1pbm9sb2d5LmhsNy5vcmcvQ29kZVN5c3RlbS92My1BY3RDb2RlIn0sImlkIjoiNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyIiwicGFydGljaXBhbnQiOlt7ImluZGl2aWR1YWwiOnsiZGlzcGxheSI6IkpvaG4gSGFuY29jayIsInJlZmVyZW5jZSI6InVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYyJ9fV0sInBlcmlvZCI6eyJlbmQiOiIyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwIiwic3RhcnQiOiIyMDIxLTEwLTI1VDIwOjEwOjI5LTA3OjAwIn0sInJlc291cmNlVHlwZSI6IkVuY291bnRlciIsInNlcnZpY2VQcm92aWRlciI6eyJkaXNwbGF5IjoiQ0RFWCBFeGFtcGxlIE9yZ2FuaXphdGlvbiIsInJlZmVyZW5jZSI6InVybjp1dWlkOmUzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhMyJ9LCJzdGF0dXMiOiJmaW5pc2hlZCIsInN1YmplY3QiOnsiZGlzcGxheSI6IkNERVggRXhhbXBsZSBQYXRpZW50IiwicmVmZXJlbmNlIjoidXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlIn0sInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyXCIgPC9wPjwvZGl2PjxwPjxiPnN0YXR1czwvYj46IGZpbmlzaGVkPC9wPjxwPjxiPmNsYXNzPC9iPjogZW1lcmdlbmN5IChEZXRhaWxzOiBodHRwOi8vdGVybWlub2xvZ3kuaGw3Lm9yZy9Db2RlU3lzdGVtL3YzLUFjdENvZGUgY29kZSBFTUVSID0gJ2VtZXJnZW5jeScsIHN0YXRlZCBhcyAnbnVsbCcpPC9wPjxwPjxiPnR5cGU8L2I-OiBVbmtub3duIChxdWFsaWZpZXIgdmFsdWUpIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vYnJvd3Nlci5paHRzZG90b29scy5vcmcvXCI-U05PTUVEIENUPC9hPiMyNjE2NjUwMDYpPC9zcGFuPjwvcD48cD48Yj5zdWJqZWN0PC9iPjogPGEgaHJlZj1cIiNQYXRpZW50Xzk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZVwiPlNlZSBhYm92ZSAodXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlOiBDREVYIEV4YW1wbGUgUGF0aWVudCk8L2E-PC9wPjxoMz5QYXJ0aWNpcGFudHM8L2gzPjx0YWJsZSBjbGFzcz1cImdyaWRcIj48dHI-PHRkPi08L3RkPjx0ZD48Yj5JbmRpdmlkdWFsPC9iPjwvdGQ-PC90cj48dHI-PHRkPio8L3RkPjx0ZD48YSBocmVmPVwiI1ByYWN0aXRpb25lcl8wODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmNcIj5TZWUgYWJvdmUgKHVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYzogSm9obiBIYW5jb2NrKTwvYT48L3RkPjwvdHI-PC90YWJsZT48cD48Yj5wZXJpb2Q8L2I-OiAyMDIxLTEwLTI1VDIwOjEwOjI5LTA3OjAwIC0tJmd0OyAyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwPC9wPjxwPjxiPnNlcnZpY2VQcm92aWRlcjwvYj46IDxhIGhyZWY9XCIjT3JnYW5pemF0aW9uX2UzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhM1wiPlNlZSBhYm92ZSAodXJuOnV1aWQ6ZTM3ZjAwNGItZGMxMC00MjJiLWI4MzMtY2RhYTEwYTA1NWEzOiBDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uKTwvYT48L3A-PC9kaXY-Iiwic3RhdHVzIjoiZ2VuZXJhdGVkIn0sInR5cGUiOlt7ImNvZGluZyI6W3siY29kZSI6IjI2MTY2NTAwNiIsImRpc3BsYXkiOiJVbmtub3duIChxdWFsaWZpZXIgdmFsdWUpIiwic3lzdGVtIjoiaHR0cDovL3Nub21lZC5pbmZvL3NjdCJ9XSwidGV4dCI6IlVua25vd24gKHF1YWxpZmllciB2YWx1ZSkifV19fSx7ImZ1bGxVcmwiOiJ1cm46dXVpZDplMzdmMDA0Yi1kYzEwLTQyMmItYjgzMy1jZGFhMTBhMDU1YTMiLCJyZXNvdXJjZSI6eyJhY3RpdmUiOnRydWUsImFkZHJlc3MiOlt7ImNpdHkiOiJCb3N0b24iLCJjb3VudHJ5IjoiVVNBIiwibGluZSI6WyIxIENERVggTGFuZSJdLCJwb3N0YWxDb2RlIjoiMDEwMDIiLCJzdGF0ZSI6Ik1BIn1dLCJpZCI6ImUzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhMyIsIm5hbWUiOiJDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uIiwicmVzb3VyY2VUeXBlIjoiT3JnYW5pemF0aW9uIiwidGVsZWNvbSI6W3sic3lzdGVtIjoicGhvbmUiLCJ2YWx1ZSI6IigrMSkgNTU1LTU1NS01NTU1In0seyJzeXN0ZW0iOiJlbWFpbCIsInZhbHVlIjoiY3VzdG9tZXItc2VydmljZUBleGFtcGxlLm9yZyJ9XSwidGV4dCI6eyJkaXYiOiI8ZGl2IHhtbG5zPVwiaHR0cDovL3d3dy53My5vcmcvMTk5OS94aHRtbFwiPjxwPjxiPkdlbmVyYXRlZCBOYXJyYXRpdmU8L2I-PC9wPjxkaXYgc3R5bGU9XCJkaXNwbGF5OiBpbmxpbmUtYmxvY2s7IGJhY2tncm91bmQtY29sb3I6ICNkOWUwZTc7IHBhZGRpbmc6IDZweDsgbWFyZ2luOiA0cHg7IGJvcmRlcjogMXB4IHNvbGlkICM4ZGExYjQ7IGJvcmRlci1yYWRpdXM6IDVweDsgbGluZS1oZWlnaHQ6IDYwJVwiPjxwIHN0eWxlPVwibWFyZ2luLWJvdHRvbTogMHB4XCI-UmVzb3VyY2UgXCJlMzdmMDA0Yi1kYzEwLTQyMmItYjgzMy1jZGFhMTBhMDU1YTNcIiA8L3A-PC9kaXY-PHA-PGI-YWN0aXZlPC9iPjogdHJ1ZTwvcD48cD48Yj5uYW1lPC9iPjogQ0RFWCBFeGFtcGxlIE9yZ2FuaXphdGlvbjwvcD48cD48Yj50ZWxlY29tPC9iPjogcGg6ICgrMSkgNTU1LTU1NS01NTU1LCA8YSBocmVmPVwibWFpbHRvOmN1c3RvbWVyLXNlcnZpY2VAZXhhbXBsZS5vcmdcIj5jdXN0b21lci1zZXJ2aWNlQGV4YW1wbGUub3JnPC9hPjwvcD48cD48Yj5hZGRyZXNzPC9iPjogMSBDREVYIExhbmUgQm9zdG9uIE1BIDAxMDAyIFVTQSA8L3A-PC9kaXY-Iiwic3RhdHVzIjoiZ2VuZXJhdGVkIn19fV0sImlkZW50aWZpZXIiOnsic3lzdGVtIjoidXJuOmlldGY6cmZjOjM5ODYiLCJ2YWx1ZSI6InVybjp1dWlkOmMxNzM1MzVlLTEzNWUtNDhlMy1hYjY0LTM4YmFjYzY4ZGJhOCJ9LCJyZXNvdXJjZVR5cGUiOiJCdW5kbGUiLCJ0aW1lc3RhbXAiOiIyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwIiwidHlwZSI6ImRvY3VtZW50In0

signature:
JAET6A3W8KXfOYOE-gM4yfSmN0uMInsj3CrMUtQRcOKZ4V4I9-aZxavMXUnuoIznKj9rBir-O8tFCfjbLjrkXv4SVVuuLiFOW4YigjRYH_Dg4LuwiT72kYGoRYVH14rqSVYCOEBVnWAVT25xAJ05Lu5z2Z5JQ5ReuLIjXd8rSYZbpLaF8jBxKWFBo_L2_6RtqTdNo3OkRYgtP5NgiwtOIyoWBw-XBaXAtFtNdWCU14vOk_tJJ0Sg6lYojE881qWUsi1BgFWfswa1xJXIa8XcpA_-kdTvlYiO2ZJOqXuyJt2_xjA9AV4mx3Tmmxl7q6xcgyOlQBKLBUWJUGET_1ddHdVV6uIC_93OyO9FL_Szw3iWElGLtXerLbEHGlDmR8OJU--NaJCeyDVnbYAeLEkeSu6Kpc0K_nrZzvr8Rn-_nI3C1UjXSN24th_sOkYbQ63NsFgifJlyY8uLS-uu6jWd3Wadydq7J6haX9BB9wtB0bRWzqYutvCYlvygxzFAD9ui
</pre>


**3.4. Create detached payload by removing the payload from the JWS**

note the signature is displayed with the parts labeled and separated with line breaks for easier viewing then as compact serialization format


```python
split_sig = signature.split('.')
split_sig[1] = ''
signature = '.'.join(split_sig)
for i,j in enumerate(signature.split('.')):
    print(f'{labels[i]}:')
    print(f'{j}')
    print()
print(f'\nSignature in compact serialization format:\n{"="*80}\n{signature}')
```

<pre style="border:0; overflow-wrap:break-word;">
header:
eyJhbGciOiJSUzI1NiIsImt0eSI6IlJTIiwidHlwIjoiSldUIiwieDVjIjpbIk1JSUUzekNDQTBlZ0F3SUJBZ0lKQU9LRll2TXdSK3lRTUEwR0NTcUdTSWIzRFFFQkN3VUFNSUdOTVFzd0NRWURWUVFHRXdKVlV6RVRNQkVHQTFVRUNBd0tRMkZzYVdadmNtNXBZVEVTTUJBR0ExVUVCd3dKVTJGMWMyRnNhWFJ2TVJVd0V3WURWUVFLREF4SVpXRnNkR2hsUkdGMFlURXhGekFWQmdOVkJBTU1Ea1Z5YVdNZ1NHRmhjeXdnUkZaTk1TVXdJd1lKS29aSWh2Y05BUWtCRmhabGFHRmhjMEJvWldGc2RHaGxaR0YwWVRFdWIzSm5NQjRYRFRJeE1UQXlOekUzTkRJd05Gb1hEVEl5TVRBeU1qRTNOREl3TkZvd2dZMHhDekFKQmdOVkJBWVRBbFZUTVJNd0VRWURWUVFJREFwRFlXeHBabTl5Ym1saE1SSXdFQVlEVlFRSERBbFRZWFZ6WVd4cGRHOHhGVEFUQmdOVkJBb01ERWhsWVd4MGFHVkVZWFJoTVRFWE1CVUdBMVVFQXd3T1JYSnBZeUJJWVdGekxDQkVWazB4SlRBakJna3Foa2lHOXcwQkNRRVdGbVZvWVdGelFHaGxZV3gwYUdWa1lYUmhNUzV2Y21jd2dnR2lNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUJqd0F3Z2dHS0FvSUJnUURwS2NTa29BTTZzVzIxK3ZXVGVJVk9HeDEwTVdhc1F5N1ZIaWQ2enlxWEFCTSt6bmZCblhlbnlVMGoxRlR2UG1SZk9Eb09EWFZ1UFV3RG9taENIaCtiY2xXOUtNMm81NjNjeFJLRXZCbmFIcnNqdzV5Tm14TzVZakVSYmh0SGRRZXFrdGR3M1ZZRVJSOUhveExPM0Zrc3pSMjkySFRCNHhXM3lXbFYzZ1RrTVFvelBTY0pLSDNiRzhQcXE2QVlQSjdDNFlCSWxVU2RCTVZsM3FuZUVmZzdmdXhpRmZYb2ZkVFZtN3JNaWlHN1g5ejQzUGZpbHFhZWlzZm10UnhBbFJ3RU5YckgzT3ZPRFB5TDByVG5HOENzYkFYWVZJTW1kZEhlNFpGOXBsaDk1c2o0cE1UaEx0Y0pYL285WEhMamg3RW1aeWdKSFdFUXE0UHdGd1pkbWJjZmhDbU9yODhIOEJiVXJ1LzdWNnpic0cxTjFDV2xuZGxiVnpuTCszSU1PcjhrWGFIY2FucWZja2dGVjRFcm5makZKcTFPSWFBbXNNajg1eE1ranlYTHljTEwvdTVuMm82Qmc5My9VUmZxdU9vU0lHT0NSMjVEYVp6cHcyazNzN29FOWRNd0VXWHRmWGdZdGgyYmxqeTV0RkgwR2pwT2t4MDdqN1pUNUhueG5sc0NBd0VBQWFOQU1ENHdEQVlEVlIwVEJBVXdBd0VCL3pBTEJnTlZIUThFQkFNQ0JlQXdJUVlEVlIwUkJCb3dHSUlXZDNkM0xtaGxZV3gwYUdWa1lYUmhhVzVqTG1OdmJUQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FZRUFDdU1VTnE5YXkrK2U1WUM3UUZPOTRyZnp4R1FuRjNHa2xaTkFYbUlyN1BWR2RpR1kyR1R4LzlSdEhDd1RLemtMK3l2S29qZVo5ZFZLOHdyR1ZpUmtPL2pVeVorS2NXUm9rVWpzNTluY0pHUk1TU1J4dGVDUXVqdDRoZjIrL3FWK2Yyc01RdEVyd1BFMzB2YnFSWVVOTk5CVkVRcGFReC9hY0pEVXY5djdzakhpSkRxWHdRK3J6ajk1aUhBSWFlRUhxRi9NczIycDJiZVp1cXZJUUtlTWwrc3ZWcUh0aXV6V25GNFU2VkltcGtyNGJIbDdlZ1Y5SDZsNlQyU01rajZxRFU1ZTlOZzBabExUdG9zc2hCTG1vcEY3ZTdIeXJURUFtZk9QS1FlMEVnOUUydXJ6eHFCdUc1NGs1MEcySjBGaVBzUUpBaEZpTkd3U2c0UzNIeVZERzd1ZUtkMEw5M3dLT05PWUd2TUtpekNIQitwS3ZFTUpvWjh5OXVpQitIRlhjcDlSYUpxSjk3SHBaVEV2K2xpQ3AyUFNYemNLMHIyNVNjeWpGNmRMb3VLMlNCMzB4QXZKOHRFNTg0K2pxUTZDR2VjVTlYanZsQWp1SmRDckRlVlBzamtuN09QWEcrOFhaVTd6cUhaTm1YWDFZWTRINXJnRUo0OGxyVXJQM0k4UiJdfQ

payload:


signature:
JAET6A3W8KXfOYOE-gM4yfSmN0uMInsj3CrMUtQRcOKZ4V4I9-aZxavMXUnuoIznKj9rBir-O8tFCfjbLjrkXv4SVVuuLiFOW4YigjRYH_Dg4LuwiT72kYGoRYVH14rqSVYCOEBVnWAVT25xAJ05Lu5z2Z5JQ5ReuLIjXd8rSYZbpLaF8jBxKWFBo_L2_6RtqTdNo3OkRYgtP5NgiwtOIyoWBw-XBaXAtFtNdWCU14vOk_tJJ0Sg6lYojE881qWUsi1BgFWfswa1xJXIa8XcpA_-kdTvlYiO2ZJOqXuyJt2_xjA9AV4mx3Tmmxl7q6xcgyOlQBKLBUWJUGET_1ddHdVV6uIC_93OyO9FL_Szw3iWElGLtXerLbEHGlDmR8OJU--NaJCeyDVnbYAeLEkeSu6Kpc0K_nrZzvr8Rn-_nI3C1UjXSN24th_sOkYbQ63NsFgifJlyY8uLS-uu6jWd3Wadydq7J6haX9BB9wtB0bRWzqYutvCYlvygxzFAD9ui


Signature in compact serialization format:
================================================================================
eyJhbGciOiJSUzI1NiIsImt0eSI6IlJTIiwidHlwIjoiSldUIiwieDVjIjpbIk1JSUUzekNDQTBlZ0F3SUJBZ0lKQU9LRll2TXdSK3lRTUEwR0NTcUdTSWIzRFFFQkN3VUFNSUdOTVFzd0NRWURWUVFHRXdKVlV6RVRNQkVHQTFVRUNBd0tRMkZzYVdadmNtNXBZVEVTTUJBR0ExVUVCd3dKVTJGMWMyRnNhWFJ2TVJVd0V3WURWUVFLREF4SVpXRnNkR2hsUkdGMFlURXhGekFWQmdOVkJBTU1Ea1Z5YVdNZ1NHRmhjeXdnUkZaTk1TVXdJd1lKS29aSWh2Y05BUWtCRmhabGFHRmhjMEJvWldGc2RHaGxaR0YwWVRFdWIzSm5NQjRYRFRJeE1UQXlOekUzTkRJd05Gb1hEVEl5TVRBeU1qRTNOREl3TkZvd2dZMHhDekFKQmdOVkJBWVRBbFZUTVJNd0VRWURWUVFJREFwRFlXeHBabTl5Ym1saE1SSXdFQVlEVlFRSERBbFRZWFZ6WVd4cGRHOHhGVEFUQmdOVkJBb01ERWhsWVd4MGFHVkVZWFJoTVRFWE1CVUdBMVVFQXd3T1JYSnBZeUJJWVdGekxDQkVWazB4SlRBakJna3Foa2lHOXcwQkNRRVdGbVZvWVdGelFHaGxZV3gwYUdWa1lYUmhNUzV2Y21jd2dnR2lNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUJqd0F3Z2dHS0FvSUJnUURwS2NTa29BTTZzVzIxK3ZXVGVJVk9HeDEwTVdhc1F5N1ZIaWQ2enlxWEFCTSt6bmZCblhlbnlVMGoxRlR2UG1SZk9Eb09EWFZ1UFV3RG9taENIaCtiY2xXOUtNMm81NjNjeFJLRXZCbmFIcnNqdzV5Tm14TzVZakVSYmh0SGRRZXFrdGR3M1ZZRVJSOUhveExPM0Zrc3pSMjkySFRCNHhXM3lXbFYzZ1RrTVFvelBTY0pLSDNiRzhQcXE2QVlQSjdDNFlCSWxVU2RCTVZsM3FuZUVmZzdmdXhpRmZYb2ZkVFZtN3JNaWlHN1g5ejQzUGZpbHFhZWlzZm10UnhBbFJ3RU5YckgzT3ZPRFB5TDByVG5HOENzYkFYWVZJTW1kZEhlNFpGOXBsaDk1c2o0cE1UaEx0Y0pYL285WEhMamg3RW1aeWdKSFdFUXE0UHdGd1pkbWJjZmhDbU9yODhIOEJiVXJ1LzdWNnpic0cxTjFDV2xuZGxiVnpuTCszSU1PcjhrWGFIY2FucWZja2dGVjRFcm5makZKcTFPSWFBbXNNajg1eE1ranlYTHljTEwvdTVuMm82Qmc5My9VUmZxdU9vU0lHT0NSMjVEYVp6cHcyazNzN29FOWRNd0VXWHRmWGdZdGgyYmxqeTV0RkgwR2pwT2t4MDdqN1pUNUhueG5sc0NBd0VBQWFOQU1ENHdEQVlEVlIwVEJBVXdBd0VCL3pBTEJnTlZIUThFQkFNQ0JlQXdJUVlEVlIwUkJCb3dHSUlXZDNkM0xtaGxZV3gwYUdWa1lYUmhhVzVqTG1OdmJUQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FZRUFDdU1VTnE5YXkrK2U1WUM3UUZPOTRyZnp4R1FuRjNHa2xaTkFYbUlyN1BWR2RpR1kyR1R4LzlSdEhDd1RLemtMK3l2S29qZVo5ZFZLOHdyR1ZpUmtPL2pVeVorS2NXUm9rVWpzNTluY0pHUk1TU1J4dGVDUXVqdDRoZjIrL3FWK2Yyc01RdEVyd1BFMzB2YnFSWVVOTk5CVkVRcGFReC9hY0pEVXY5djdzakhpSkRxWHdRK3J6ajk1aUhBSWFlRUhxRi9NczIycDJiZVp1cXZJUUtlTWwrc3ZWcUh0aXV6V25GNFU2VkltcGtyNGJIbDdlZ1Y5SDZsNlQyU01rajZxRFU1ZTlOZzBabExUdG9zc2hCTG1vcEY3ZTdIeXJURUFtZk9QS1FlMEVnOUUydXJ6eHFCdUc1NGs1MEcySjBGaVBzUUpBaEZpTkd3U2c0UzNIeVZERzd1ZUtkMEw5M3dLT05PWUd2TUtpekNIQitwS3ZFTUpvWjh5OXVpQitIRlhjcDlSYUpxSjk3SHBaVEV2K2xpQ3AyUFNYemNLMHIyNVNjeWpGNmRMb3VLMlNCMzB4QXZKOHRFNTg0K2pxUTZDR2VjVTlYanZsQWp1SmRDckRlVlBzamtuN09QWEcrOFhaVTd6cUhaTm1YWDFZWTRINXJnRUo0OGxyVXJQM0k4UiJdfQ..JAET6A3W8KXfOYOE-gM4yfSmN0uMInsj3CrMUtQRcOKZ4V4I9-aZxavMXUnuoIznKj9rBir-O8tFCfjbLjrkXv4SVVuuLiFOW4YigjRYH_Dg4LuwiT72kYGoRYVH14rqSVYCOEBVnWAVT25xAJ05Lu5z2Z5JQ5ReuLIjXd8rSYZbpLaF8jBxKWFBo_L2_6RtqTdNo3OkRYgtP5NgiwtOIyoWBw-XBaXAtFtNdWCU14vOk_tJJ0Sg6lYojE881qWUsi1BgFWfswa1xJXIa8XcpA_-kdTvlYiO2ZJOqXuyJt2_xjA9AV4mx3Tmmxl7q6xcgyOlQBKLBUWJUGET_1ddHdVV6uIC_93OyO9FL_Szw3iWElGLtXerLbEHGlDmR8OJU--NaJCeyDVnbYAeLEkeSu6Kpc0K_nrZzvr8Rn-_nI3C1UjXSN24th_sOkYbQ63NsFgifJlyY8uLS-uu6jWd3Wadydq7J6haX9BB9wtB0bRWzqYutvCYlvygxzFAD9ui
</pre>

**4. base64 the JWS and add the Signature element to the Bundle**

this is what would be contained and/or referenced by TASK over-the-wire


```python
from base64 import b64encode
from json import loads,dumps
b64_jws = b64encode(signature.encode()).decode()
sig_element = {
            "type": [  # Signature.type = Verification Signature
              {
                "system": "urn:iso-astm:E1762-95:2013",
                "code": "1.2.840.10065.1.12.1.5",
                "display": "Verification Signature"
              }
            ],
            "when": "2021-10-05T22:42:19-07:00", #system timestamp when signature created
            "who": { #Reference to the Practitioner who signed and attested to the Bundle
              "reference": "Practitioner/123"    
            },
            "onBehalfOf": { #Reference to the Organization
              "reference": "Organization/123"   
            },
            "data": b64_jws,
             }

document_bundle = loads(payload)
document_bundle['id'] = document_bundle_id # add id back in
document_bundle['meta'] = document_bundle_meta # add meta back in
document_bundle['signature'] = sig_element
print(dumps(document_bundle, indent=2))
```

<pre style="border:0; overflow-wrap:break-word;">
{
  "entry": [
    {
      "fullUrl": "urn:uuid:17a80a8d-4cf1-4deb-a1fd-2db1130e5f76",
      "resource": {
        "attester": [
          {
            "mode": "legal",
            "party": {
              "display": "Example Practitioner",
              "reference": "urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"
            },
            "time": "2021-10-25T20:16:29-07:00"
          }
        ],
        "author": [
          {
            "display": "Example Practitioner",
            "reference": "urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"
          }
        ],
        "date": "2021-10-25T20:16:29-07:00",
        "encounter": {
          "display": "Example Encounter",
          "reference": "urn:uuid:5ce5c83a-000f-47d2-941c-039358cc9112"
        },
        "id": "17a80a8d-4cf1-4deb-a1fd-2db1130e5f76",
        "resourceType": "Composition",
        "section": [
          {
            "entry": [
              {
                "reference": "urn:uuid:014a68ec-d691-49e0-b980-91b0d924e570"
              }
            ],
            "title": "Active Condition 1"
          }
        ],
        "status": "final",
        "subject": {
          "display": "Example Patient",
          "reference": "urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece"
        },
        "text": {
          "div": "&lt;div xmlns=\"http://www.w3.org/1999/xhtml\"&gt;&lt;p&gt;&lt;b&gt;Generated Narrative&lt;/b&gt;&lt;/p&gt;&lt;div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"&gt;&lt;p style=\"margin-bottom: 0px\"&gt;Resource \"17a80a8d-4cf1-4deb-a1fd-2db1130e5f76\" &lt;/p&gt;&lt;/div&gt;&lt;p&gt;&lt;b&gt;status&lt;/b&gt;: final&lt;/p&gt;&lt;p&gt;&lt;b&gt;type&lt;/b&gt;: Medical records &lt;span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"&gt; (&lt;a href=\"https://loinc.org/\"&gt;LOINC&lt;/a&gt;#11503-0)&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;encounter&lt;/b&gt;: &lt;a href=\"#Encounter_5ce5c83a-000f-47d2-941c-039358cc9112\"&gt;See above (urn:uuid:5ce5c83a-000f-47d2-941c-039358cc9112: Example Encounter)&lt;/a&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;date&lt;/b&gt;: 2021-10-25T20:16:29-07:00&lt;/p&gt;&lt;p&gt;&lt;b&gt;author&lt;/b&gt;: &lt;a href=\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\"&gt;See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: Example Practitioner)&lt;/a&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;title&lt;/b&gt;: Active Conditions&lt;/p&gt;&lt;h3&gt;Attesters&lt;/h3&gt;&lt;table class=\"grid\"&gt;&lt;tr&gt;&lt;td&gt;-&lt;/td&gt;&lt;td&gt;&lt;b&gt;Mode&lt;/b&gt;&lt;/td&gt;&lt;td&gt;&lt;b&gt;Time&lt;/b&gt;&lt;/td&gt;&lt;td&gt;&lt;b&gt;Party&lt;/b&gt;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;*&lt;/td&gt;&lt;td&gt;legal&lt;/td&gt;&lt;td&gt;2021-10-25T20:16:29-07:00&lt;/td&gt;&lt;td&gt;&lt;a href=\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\"&gt;See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: Example Practitioner)&lt;/a&gt;&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;/div&gt;",
          "status": "generated"
        },
        "title": "Active Conditions",
        "type": {
          "coding": [
            {
              "code": "11503-0",
              "system": "http://loinc.org"
            }
          ],
          "text": "Medical records"
        }
      }
    },
    {
      "fullUrl": "urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc",
      "resource": {
        "id": "0820c16d-91de-4dfa-a3a6-f140a516a9bc",
        "meta": {
          "lastUpdated": "2013-05-05T16:13:03Z"
        },
        "name": [
          {
            "family": "Hancock",
            "given": [
              "John"
            ]
          }
        ],
        "resourceType": "Practitioner",
        "text": {
          "div": "&lt;div xmlns=\"http://www.w3.org/1999/xhtml\"&gt;&lt;p&gt;&lt;b&gt;Generated Narrative&lt;/b&gt;&lt;/p&gt;&lt;div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"&gt;&lt;p style=\"margin-bottom: 0px\"&gt;Resource \"0820c16d-91de-4dfa-a3a6-f140a516a9bc\" Updated \"2013-05-05T16:13:03Z\" &lt;/p&gt;&lt;/div&gt;&lt;p&gt;&lt;b&gt;name&lt;/b&gt;: John Hancock &lt;/p&gt;&lt;/div&gt;",
          "status": "generated"
        }
      }
    },
    {
      "fullUrl": "urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece",
      "resource": {
        "active": true,
        "id": "970af6c9-5bbd-4067-b6c1-d9b2c823aece",
        "name": [
          {
            "family": "Patient",
            "given": [
              "CDEX Example"
            ],
            "text": "CDEX Example Patient"
          }
        ],
        "resourceType": "Patient",
        "text": {
          "div": "&lt;div xmlns=\"http://www.w3.org/1999/xhtml\"&gt;&lt;p&gt;&lt;b&gt;Generated Narrative&lt;/b&gt;&lt;/p&gt;&lt;div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"&gt;&lt;p style=\"margin-bottom: 0px\"&gt;Resource \"970af6c9-5bbd-4067-b6c1-d9b2c823aece\" &lt;/p&gt;&lt;/div&gt;&lt;p&gt;&lt;b&gt;active&lt;/b&gt;: true&lt;/p&gt;&lt;p&gt;&lt;b&gt;name&lt;/b&gt;: CDEX Example Patient&lt;/p&gt;&lt;/div&gt;",
          "status": "generated"
        }
      }
    },
    {
      "fullUrl": "urn:uuid:014a68ec-d691-49e0-b980-91b0d924e570",
      "resource": {
        "asserter": {
          "reference": "urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"
        },
        "category": [
          {
            "coding": [
              {
                "code": "55607006",
                "display": "Problem",
                "system": "http://snomed.info/sct"
              },
              {
                "code": "75326-9",
                "display": "Problem",
                "system": "http://loinc.org"
              }
            ]
          }
        ],
        "clinicalStatus": {
          "coding": [
            {
              "code": "active",
              "system": "http://terminology.hl7.org/CodeSystem/condition-clinical"
            }
          ]
        },
        "code": {
          "coding": [
            {
              "code": "44054006",
              "display": "Type 2 Diabetes Mellitus",
              "system": "http://snomed.info/sct"
            }
          ]
        },
        "id": "014a68ec-d691-49e0-b980-91b0d924e570",
        "identifier": [
          {
            "system": "urn:oid:1.3.6.1.4.1.22812.4.111.0.4.1.2.1",
            "value": "1"
          }
        ],
        "onsetDateTime": "2006",
        "resourceType": "Condition",
        "subject": {
          "reference": "urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece"
        },
        "text": {
          "div": "&lt;div xmlns=\"http://www.w3.org/1999/xhtml\"&gt;&lt;p&gt;&lt;b&gt;Generated Narrative&lt;/b&gt;&lt;/p&gt;&lt;div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"&gt;&lt;p style=\"margin-bottom: 0px\"&gt;Resource \"014a68ec-d691-49e0-b980-91b0d924e570\" &lt;/p&gt;&lt;/div&gt;&lt;p&gt;&lt;b&gt;identifier&lt;/b&gt;: id: 1&lt;/p&gt;&lt;p&gt;&lt;b&gt;clinicalStatus&lt;/b&gt;: Active &lt;span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"&gt; (&lt;a href=\"http://terminology.hl7.org/3.0.0/CodeSystem-condition-clinical.html\"&gt;Condition Clinical Status Codes&lt;/a&gt;#active)&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;category&lt;/b&gt;: Problem &lt;span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"&gt; (&lt;a href=\"https://browser.ihtsdotools.org/\"&gt;SNOMED CT&lt;/a&gt;#55607006; &lt;a href=\"https://loinc.org/\"&gt;LOINC&lt;/a&gt;#75326-9)&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;code&lt;/b&gt;: Type 2 Diabetes Mellitus &lt;span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"&gt; (&lt;a href=\"https://browser.ihtsdotools.org/\"&gt;SNOMED CT&lt;/a&gt;#44054006)&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;subject&lt;/b&gt;: &lt;a href=\"#Patient_970af6c9-5bbd-4067-b6c1-d9b2c823aece\"&gt;See above (urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece)&lt;/a&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;onset&lt;/b&gt;: 2006-01-01&lt;/p&gt;&lt;p&gt;&lt;b&gt;asserter&lt;/b&gt;: &lt;a href=\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\"&gt;See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc)&lt;/a&gt;&lt;/p&gt;&lt;/div&gt;",
          "status": "generated"
        }
      }
    },
    {
      "fullUrl": "urn:uuid:5ce5c83a-000f-47d2-941c-039358cc9112",
      "resource": {
        "class": {
          "code": "EMER",
          "system": "http://terminology.hl7.org/CodeSystem/v3-ActCode"
        },
        "id": "5ce5c83a-000f-47d2-941c-039358cc9112",
        "participant": [
          {
            "individual": {
              "display": "John Hancock",
              "reference": "urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"
            }
          }
        ],
        "period": {
          "end": "2021-10-25T20:16:29-07:00",
          "start": "2021-10-25T20:10:29-07:00"
        },
        "resourceType": "Encounter",
        "serviceProvider": {
          "display": "CDEX Example Organization",
          "reference": "urn:uuid:e37f004b-dc10-422b-b833-cdaa10a055a3"
        },
        "status": "finished",
        "subject": {
          "display": "CDEX Example Patient",
          "reference": "urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece"
        },
        "text": {
          "div": "&lt;div xmlns=\"http://www.w3.org/1999/xhtml\"&gt;&lt;p&gt;&lt;b&gt;Generated Narrative&lt;/b&gt;&lt;/p&gt;&lt;div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"&gt;&lt;p style=\"margin-bottom: 0px\"&gt;Resource \"5ce5c83a-000f-47d2-941c-039358cc9112\" &lt;/p&gt;&lt;/div&gt;&lt;p&gt;&lt;b&gt;status&lt;/b&gt;: finished&lt;/p&gt;&lt;p&gt;&lt;b&gt;class&lt;/b&gt;: emergency (Details: http://terminology.hl7.org/CodeSystem/v3-ActCode code EMER = 'emergency', stated as 'null')&lt;/p&gt;&lt;p&gt;&lt;b&gt;type&lt;/b&gt;: Unknown (qualifier value) &lt;span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"&gt; (&lt;a href=\"https://browser.ihtsdotools.org/\"&gt;SNOMED CT&lt;/a&gt;#261665006)&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;subject&lt;/b&gt;: &lt;a href=\"#Patient_970af6c9-5bbd-4067-b6c1-d9b2c823aece\"&gt;See above (urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece: CDEX Example Patient)&lt;/a&gt;&lt;/p&gt;&lt;h3&gt;Participants&lt;/h3&gt;&lt;table class=\"grid\"&gt;&lt;tr&gt;&lt;td&gt;-&lt;/td&gt;&lt;td&gt;&lt;b&gt;Individual&lt;/b&gt;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;*&lt;/td&gt;&lt;td&gt;&lt;a href=\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\"&gt;See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: John Hancock)&lt;/a&gt;&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;p&gt;&lt;b&gt;period&lt;/b&gt;: 2021-10-25T20:10:29-07:00 --&gt; 2021-10-25T20:16:29-07:00&lt;/p&gt;&lt;p&gt;&lt;b&gt;serviceProvider&lt;/b&gt;: &lt;a href=\"#Organization_e37f004b-dc10-422b-b833-cdaa10a055a3\"&gt;See above (urn:uuid:e37f004b-dc10-422b-b833-cdaa10a055a3: CDEX Example Organization)&lt;/a&gt;&lt;/p&gt;&lt;/div&gt;",
          "status": "generated"
        },
        "type": [
          {
            "coding": [
              {
                "code": "261665006",
                "display": "Unknown (qualifier value)",
                "system": "http://snomed.info/sct"
              }
            ],
            "text": "Unknown (qualifier value)"
          }
        ]
      }
    },
    {
      "fullUrl": "urn:uuid:e37f004b-dc10-422b-b833-cdaa10a055a3",
      "resource": {
        "active": true,
        "address": [
          {
            "city": "Boston",
            "country": "USA",
            "line": [
              "1 CDEX Lane"
            ],
            "postalCode": "01002",
            "state": "MA"
          }
        ],
        "id": "e37f004b-dc10-422b-b833-cdaa10a055a3",
        "name": "CDEX Example Organization",
        "resourceType": "Organization",
        "telecom": [
          {
            "system": "phone",
            "value": "(+1) 555-555-5555"
          },
          {
            "system": "email",
            "value": "customer-service@example.org"
          }
        ],
        "text": {
          "div": "&lt;div xmlns=\"http://www.w3.org/1999/xhtml\"&gt;&lt;p&gt;&lt;b&gt;Generated Narrative&lt;/b&gt;&lt;/p&gt;&lt;div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"&gt;&lt;p style=\"margin-bottom: 0px\"&gt;Resource \"e37f004b-dc10-422b-b833-cdaa10a055a3\" &lt;/p&gt;&lt;/div&gt;&lt;p&gt;&lt;b&gt;active&lt;/b&gt;: true&lt;/p&gt;&lt;p&gt;&lt;b&gt;name&lt;/b&gt;: CDEX Example Organization&lt;/p&gt;&lt;p&gt;&lt;b&gt;telecom&lt;/b&gt;: ph: (+1) 555-555-5555, &lt;a href=\"mailto:customer-service@example.org\"&gt;customer-service@example.org&lt;/a&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;address&lt;/b&gt;: 1 CDEX Lane Boston MA 01002 USA &lt;/p&gt;&lt;/div&gt;",
          "status": "generated"
        }
      }
    }
  ],
  "identifier": {
    "system": "urn:ietf:rfc:3986",
    "value": "urn:uuid:c173535e-135e-48e3-ab64-38bacc68dba8"
  },
  "resourceType": "Bundle",
  "timestamp": "2021-10-25T20:16:29-07:00",
  "type": "document",
  "id": "cdex-document-digital-sig-example",
  "meta": {
    "extension": [
      {
        "url": "http://hl7.org/fhir/StructureDefinition/instance-name",
        "valueString": "CDEX Document with Digital Signature Example"
      },
      {
        "url": "http://hl7.org/fhir/StructureDefinition/instance-description",
        "valueMarkdown": "Digital signature example showing how it is used to sign a FHIR Document.  The CDEX use case would be the target resource in response to a Task-based request where an digital signature was required.  If no signature was required, the response would typically be in the form of an individual resource."
      }
    ]
  },
  "signature": {
    "type": [
      {
        "system": "urn:iso-astm:E1762-95:2013",
        "code": "1.2.840.10065.1.12.1.5",
        "display": "Verification Signature"
      }
    ],
    "when": "2021-10-05T22:42:19-07:00",
    "who": {
      "reference": "Practitioner/123"
    },
    "onBehalfOf": {
      "reference": "Organization/123"
    },
    "data": "ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXQwZVNJNklsSlRJaXdpZEhsd0lqb2lTbGRVSWl3aWVEVmpJanBiSWsxSlNVVXpla05EUVRCbFowRjNTVUpCWjBsS1FVOUxSbGwyVFhkU0szbFJUVUV3UjBOVGNVZFRTV0l6UkZGRlFrTjNWVUZOU1VkT1RWRnpkME5SV1VSV1VWRkhSWGRLVmxWNlJWUk5Ra1ZIUVRGVlJVTkJkMHRSTWtaellWZGFkbU50TlhCWlZFVlRUVUpCUjBFeFZVVkNkM2RLVlRKR01XTXlSbk5oV0ZKMlRWSlZkMFYzV1VSV1VWRkxSRUY0U1ZwWFJuTmtSMmhzVWtkR01GbFVSWGhHZWtGV1FtZE9Wa0pCVFUxRWExWjVZVmROWjFOSFJtaGplWGRuVWtaYVRrMVRWWGRKZDFsS1MyOWFTV2gyWTA1QlVXdENSbWhhYkdGSFJtaGpNRUp2V2xkR2MyUkhhR3hhUjBZd1dWUkZkV0l6U201TlFqUllSRlJKZUUxVVFYbE9la1V6VGtSSmQwNUdiMWhFVkVsNVRWUkJlVTFxUlROT1JFbDNUa1p2ZDJkWk1IaERla0ZLUW1kT1ZrSkJXVlJCYkZaVVRWSk5kMFZSV1VSV1VWRkpSRUZ3UkZsWGVIQmFiVGw1WW0xc2FFMVNTWGRGUVZsRVZsRlJTRVJCYkZSWldGWjZXVmQ0Y0dSSE9IaEdWRUZVUW1kT1ZrSkJiMDFFUldoc1dWZDRNR0ZIVmtWWldGSm9UVlJGV0UxQ1ZVZEJNVlZGUVhkM1QxSllTbkJaZVVKSldWZEdla3hEUWtWV2F6QjRTbFJCYWtKbmEzRm9hMmxIT1hjd1FrTlJSVmRHYlZadldWZEdlbEZIYUd4WlYzZ3dZVWRXYTFsWVVtaE5VelYyWTIxamQyZG5SMmxOUVRCSFExTnhSMU5KWWpORVVVVkNRVkZWUVVFMFNVSnFkMEYzWjJkSFMwRnZTVUpuVVVSd1MyTlRhMjlCVFRaelZ6SXhLM1pYVkdWSlZrOUhlREV3VFZkaGMxRjVOMVpJYVdRMmVubHhXRUZDVFN0NmJtWkNibGhsYm5sVk1Hb3hSbFIyVUcxU1prOUViMDlFV0ZaMVVGVjNSRzl0YUVOSWFDdGlZMnhYT1V0Tk1tODFOak5qZUZKTFJYWkNibUZJY25OcWR6VjVUbTE0VHpWWmFrVlNZbWgwU0dSUlpYRnJkR1IzTTFaWlJWSlNPVWh2ZUV4UE0wWnJjM3BTTWpreVNGUkNOSGhYTTNsWGJGWXpaMVJyVFZGdmVsQlRZMHBMU0ROaVJ6aFFjWEUyUVZsUVNqZERORmxDU1d4VlUyUkNUVlpzTTNGdVpVVm1aemRtZFhocFJtWlliMlprVkZadE4zSk5hV2xITjFnNWVqUXpVR1pwYkhGaFpXbHpabTEwVW5oQmJGSjNSVTVZY2tnelQzWlBSRkI1VERCeVZHNUhPRU56WWtGWVdWWkpUVzFrWkVobE5GcEdPWEJzYURrMWMybzBjRTFVYUV4MFkwcFlMMjg1V0VoTWFtZzNSVzFhZVdkS1NGZEZVWEUwVUhkR2QxcGtiV0pqWm1oRGJVOXlPRGhJT0VKaVZYSjFMemRXTm5waWMwY3hUakZEVjJ4dVpHeGlWbnB1VENzelNVMVBjamhyV0dGSVkyRnVjV1pqYTJkR1ZqUkZjbTVtYWtaS2NURlBTV0ZCYlhOTmFqZzFlRTFyYW5sWVRIbGpURXd2ZFRWdU1tODJRbWM1TXk5VlVtWnhkVTl2VTBsSFQwTlNNalZFWVZwNmNIY3lhek56TjI5Rk9XUk5kMFZYV0hSbVdHZFpkR2d5WW14cWVUVjBSa2d3UjJwd1QydDRNRGRxTjFwVU5VaHVlRzVzYzBOQmQwVkJRV0ZPUVUxRU5IZEVRVmxFVmxJd1ZFSkJWWGRCZDBWQ0wzcEJURUpuVGxaSVVUaEZRa0ZOUTBKbFFYZEpVVmxFVmxJd1VrSkNiM2RIU1VsWFpETmtNMHh0YUd4WlYzZ3dZVWRXYTFsWVVtaGhWelZxVEcxT2RtSlVRVTVDWjJ0eGFHdHBSemwzTUVKQlVYTkdRVUZQUTBGWlJVRkRkVTFWVG5FNVlYa3JLMlUxV1VNM1VVWlBPVFJ5Wm5wNFIxRnVSak5IYTJ4YVRrRlliVWx5TjFCV1IyUnBSMWt5UjFSNEx6bFNkRWhEZDFSTGVtdE1LM2wyUzI5cVpWbzVaRlpMT0hkeVIxWnBVbXRQTDJwVmVWb3JTMk5YVW05clZXcHpOVGx1WTBwSFVrMVRVMUo0ZEdWRFVYVnFkRFJvWmpJckwzRldLMll5YzAxUmRFVnlkMUJGTXpCMlluRlNXVlZPVGs1Q1ZrVlJjR0ZSZUM5aFkwcEVWWFk1ZGpkemFraHBTa1J4V0hkUkszSjZhamsxYVVoQlNXRmxSVWh4Umk5TmN6SXljREppWlZwMWNYWkpVVXRsVFd3cmMzWldjVWgwYVhWNlYyNUdORlUyVmtsdGNHdHlOR0pJYkRkbFoxWTVTRFpzTmxReVUwMXJhalp4UkZVMVpUbE9aekJhYkV4VWRHOXpjMmhDVEcxdmNFWTNaVGRJZVhKVVJVRnRaazlRUzFGbE1FVm5PVVV5ZFhKNmVIRkNkVWMxTkdzMU1FY3lTakJHYVZCelVVcEJhRVpwVGtkM1UyYzBVek5JZVZaRVJ6ZDFaVXRrTUV3NU0zZExUMDVQV1VkMlRVdHBla05JUWl0d1MzWkZUVXB2V2poNU9YVnBRaXRJUmxoamNEbFNZVXB4U2prM1NIQmFWRVYySzJ4cFEzQXlVRk5ZZW1OTE1ISXlOVk5qZVdwR05tUk1iM1ZMTWxOQ016QjRRWFpLT0hSRk5UZzBLMnB4VVRaRFIyVmpWVGxZYW5ac1FXcDFTbVJEY2tSbFZsQnphbXR1TjA5UVdFY3JPRmhhVlRkNmNVaGFUbTFZV0RGWldUUklOWEpuUlVvME9HeHlWWEpRTTBrNFVpSmRmUS4uSkFFVDZBM1c4S1hmT1lPRS1nTTR5ZlNtTjB1TUluc2ozQ3JNVXRRUmNPS1o0VjRJOS1hWnhhdk1YVW51b0l6bktqOXJCaXItTzh0RkNmamJManJrWHY0U1ZWdXVMaUZPVzRZaWdqUllIX0RnNEx1d2lUNzJrWUdvUllWSDE0cnFTVllDT0VCVm5XQVZUMjV4QUowNUx1NXoyWjVKUTVSZXVMSWpYZDhyU1laYnBMYUY4akJ4S1dGQm9fTDJfNlJ0cVRkTm8zT2tSWWd0UDVOZ2l3dE9JeW9XQnctWEJhWEF0RnROZFdDVTE0dk9rX3RKSjBTZzZsWW9qRTg4MXFXVXNpMUJnRldmc3dhMXhKWElhOFhjcEFfLWtkVHZsWWlPMlpKT3FYdXlKdDJfeGpBOUFWNG14M1RtbXhsN3E2eGNneU9sUUJLTEJVV0pVR0VUXzFkZEhkVlY2dUlDXzkzT3lPOUZMX1N6dzNpV0VsR0x0WGVyTGJFSEdsRG1SOE9KVS0tTmFKQ2V5RFZuYllBZUxFa2VTdTZLcGMwS19uclp6dnI4Um4tX25JM0MxVWpYU04yNHRoX3NPa1liUTYzTnNGZ2lmSmx5WTh1TFMtdXU2aldkM1dhZHlkcTdKNmhhWDlCQjl3dEIwYlJXenFZdXR2Q1lsdnlneHpGQUQ5dWk="
  }
}

</pre>

### Receiver/Verifier Steps

**1. Remove the `Bundle.signature` element from the Search Bundle resource**

- For this example using the python dictionary object from above, but in real life, it would be contained and/or Referenced by TASK over-the-wire. Therefore it would need to be 'decontained' and/or fetched and stored in order to perform these next steps.


```python
try:
  recd_signature = document_bundle.pop("signature")
except:
  pass
recd_signature
```




<pre style="border:0; overflow-wrap:break-word;">
{'type': [{'system': 'urn:iso-astm:E1762-95:2013',
   'code': '1.2.840.10065.1.12.1.5',
   'display': 'Verification Signature'}],
 'when': '2021-10-05T22:42:19-07:00',
 'who': {'reference': 'Practitioner/123'},
 'onBehalfOf': {'reference': 'Organization/123'},
 'data': 'ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXQwZVNJNklsSlRJaXdpZEhsd0lqb2lTbGRVSWl3aWVEVmpJanBiSWsxSlNVVXpla05EUVRCbFowRjNTVUpCWjBsS1FVOUxSbGwyVFhkU0szbFJUVUV3UjBOVGNVZFRTV0l6UkZGRlFrTjNWVUZOU1VkT1RWRnpkME5SV1VSV1VWRkhSWGRLVmxWNlJWUk5Ra1ZIUVRGVlJVTkJkMHRSTWtaellWZGFkbU50TlhCWlZFVlRUVUpCUjBFeFZVVkNkM2RLVlRKR01XTXlSbk5oV0ZKMlRWSlZkMFYzV1VSV1VWRkxSRUY0U1ZwWFJuTmtSMmhzVWtkR01GbFVSWGhHZWtGV1FtZE9Wa0pCVFUxRWExWjVZVmROWjFOSFJtaGplWGRuVWtaYVRrMVRWWGRKZDFsS1MyOWFTV2gyWTA1QlVXdENSbWhhYkdGSFJtaGpNRUp2V2xkR2MyUkhhR3hhUjBZd1dWUkZkV0l6U201TlFqUllSRlJKZUUxVVFYbE9la1V6VGtSSmQwNUdiMWhFVkVsNVRWUkJlVTFxUlROT1JFbDNUa1p2ZDJkWk1IaERla0ZLUW1kT1ZrSkJXVlJCYkZaVVRWSk5kMFZSV1VSV1VWRkpSRUZ3UkZsWGVIQmFiVGw1WW0xc2FFMVNTWGRGUVZsRVZsRlJTRVJCYkZSWldGWjZXVmQ0Y0dSSE9IaEdWRUZVUW1kT1ZrSkJiMDFFUldoc1dWZDRNR0ZIVmtWWldGSm9UVlJGV0UxQ1ZVZEJNVlZGUVhkM1QxSllTbkJaZVVKSldWZEdla3hEUWtWV2F6QjRTbFJCYWtKbmEzRm9hMmxIT1hjd1FrTlJSVmRHYlZadldWZEdlbEZIYUd4WlYzZ3dZVWRXYTFsWVVtaE5VelYyWTIxamQyZG5SMmxOUVRCSFExTnhSMU5KWWpORVVVVkNRVkZWUVVFMFNVSnFkMEYzWjJkSFMwRnZTVUpuVVVSd1MyTlRhMjlCVFRaelZ6SXhLM1pYVkdWSlZrOUhlREV3VFZkaGMxRjVOMVpJYVdRMmVubHhXRUZDVFN0NmJtWkNibGhsYm5sVk1Hb3hSbFIyVUcxU1prOUViMDlFV0ZaMVVGVjNSRzl0YUVOSWFDdGlZMnhYT1V0Tk1tODFOak5qZUZKTFJYWkNibUZJY25OcWR6VjVUbTE0VHpWWmFrVlNZbWgwU0dSUlpYRnJkR1IzTTFaWlJWSlNPVWh2ZUV4UE0wWnJjM3BTTWpreVNGUkNOSGhYTTNsWGJGWXpaMVJyVFZGdmVsQlRZMHBMU0ROaVJ6aFFjWEUyUVZsUVNqZERORmxDU1d4VlUyUkNUVlpzTTNGdVpVVm1aemRtZFhocFJtWlliMlprVkZadE4zSk5hV2xITjFnNWVqUXpVR1pwYkhGaFpXbHpabTEwVW5oQmJGSjNSVTVZY2tnelQzWlBSRkI1VERCeVZHNUhPRU56WWtGWVdWWkpUVzFrWkVobE5GcEdPWEJzYURrMWMybzBjRTFVYUV4MFkwcFlMMjg1V0VoTWFtZzNSVzFhZVdkS1NGZEZVWEUwVUhkR2QxcGtiV0pqWm1oRGJVOXlPRGhJT0VKaVZYSjFMemRXTm5waWMwY3hUakZEVjJ4dVpHeGlWbnB1VENzelNVMVBjamhyV0dGSVkyRnVjV1pqYTJkR1ZqUkZjbTVtYWtaS2NURlBTV0ZCYlhOTmFqZzFlRTFyYW5sWVRIbGpURXd2ZFRWdU1tODJRbWM1TXk5VlVtWnhkVTl2VTBsSFQwTlNNalZFWVZwNmNIY3lhek56TjI5Rk9XUk5kMFZYV0hSbVdHZFpkR2d5WW14cWVUVjBSa2d3UjJwd1QydDRNRGRxTjFwVU5VaHVlRzVzYzBOQmQwVkJRV0ZPUVUxRU5IZEVRVmxFVmxJd1ZFSkJWWGRCZDBWQ0wzcEJURUpuVGxaSVVUaEZRa0ZOUTBKbFFYZEpVVmxFVmxJd1VrSkNiM2RIU1VsWFpETmtNMHh0YUd4WlYzZ3dZVWRXYTFsWVVtaGhWelZxVEcxT2RtSlVRVTVDWjJ0eGFHdHBSemwzTUVKQlVYTkdRVUZQUTBGWlJVRkRkVTFWVG5FNVlYa3JLMlUxV1VNM1VVWlBPVFJ5Wm5wNFIxRnVSak5IYTJ4YVRrRlliVWx5TjFCV1IyUnBSMWt5UjFSNEx6bFNkRWhEZDFSTGVtdE1LM2wyUzI5cVpWbzVaRlpMT0hkeVIxWnBVbXRQTDJwVmVWb3JTMk5YVW05clZXcHpOVGx1WTBwSFVrMVRVMUo0ZEdWRFVYVnFkRFJvWmpJckwzRldLMll5YzAxUmRFVnlkMUJGTXpCMlluRlNXVlZPVGs1Q1ZrVlJjR0ZSZUM5aFkwcEVWWFk1ZGpkemFraHBTa1J4V0hkUkszSjZhamsxYVVoQlNXRmxSVWh4Umk5TmN6SXljREppWlZwMWNYWkpVVXRsVFd3cmMzWldjVWgwYVhWNlYyNUdORlUyVmtsdGNHdHlOR0pJYkRkbFoxWTVTRFpzTmxReVUwMXJhalp4UkZVMVpUbE9aekJhYkV4VWRHOXpjMmhDVEcxdmNFWTNaVGRJZVhKVVJVRnRaazlRUzFGbE1FVm5PVVV5ZFhKNmVIRkNkVWMxTkdzMU1FY3lTakJHYVZCelVVcEJhRVpwVGtkM1UyYzBVek5JZVZaRVJ6ZDFaVXRrTUV3NU0zZExUMDVQV1VkMlRVdHBla05JUWl0d1MzWkZUVXB2V2poNU9YVnBRaXRJUmxoamNEbFNZVXB4U2prM1NIQmFWRVYySzJ4cFEzQXlVRk5ZZW1OTE1ISXlOVk5qZVdwR05tUk1iM1ZMTWxOQ016QjRRWFpLT0hSRk5UZzBLMnB4VVRaRFIyVmpWVGxZYW5ac1FXcDFTbVJEY2tSbFZsQnphbXR1TjA5UVdFY3JPRmhhVlRkNmNVaGFUbTFZV0RGWldUUklOWEpuUlVvME9HeHlWWEpRTTBrNFVpSmRmUS4uSkFFVDZBM1c4S1hmT1lPRS1nTTR5ZlNtTjB1TUluc2ozQ3JNVXRRUmNPS1o0VjRJOS1hWnhhdk1YVW51b0l6bktqOXJCaXItTzh0RkNmamJManJrWHY0U1ZWdXVMaUZPVzRZaWdqUllIX0RnNEx1d2lUNzJrWUdvUllWSDE0cnFTVllDT0VCVm5XQVZUMjV4QUowNUx1NXoyWjVKUTVSZXVMSWpYZDhyU1laYnBMYUY4akJ4S1dGQm9fTDJfNlJ0cVRkTm8zT2tSWWd0UDVOZ2l3dE9JeW9XQnctWEJhWEF0RnROZFdDVTE0dk9rX3RKSjBTZzZsWW9qRTg4MXFXVXNpMUJnRldmc3dhMXhKWElhOFhjcEFfLWtkVHZsWWlPMlpKT3FYdXlKdDJfeGpBOUFWNG14M1RtbXhsN3E2eGNneU9sUUJLTEJVV0pVR0VUXzFkZEhkVlY2dUlDXzkzT3lPOUZMX1N6dzNpV0VsR0x0WGVyTGJFSEdsRG1SOE9KVS0tTmFKQ2V5RFZuYllBZUxFa2VTdTZLcGMwS19uclp6dnI4Um4tX25JM0MxVWpYU04yNHRoX3NPa1liUTYzTnNGZ2lmSmx5WTh1TFMtdXU2aldkM1dhZHlkcTdKNmhhWDlCQjl3dEIwYlJXenFZdXR2Q1lsdnlneHpGQUQ5dWk='}
</pre>


**2. Canonicalize the bundle using IETF JSON Canonicalization Scheme (JCS):**

- Remove the id and meta elements if present before canonicalization


```python
document_bundle_id = document_bundle.pop("id") # remove id
document_bundle_meta = document_bundle.pop("meta") # remove meta
canonical_bundle = canonicalize(document_bundle)
canonical_bundle
```




<pre style="border:0; overflow-wrap:break-word;">

b'{"entry":[{"fullUrl":"urn:uuid:17a80a8d-4cf1-4deb-a1fd-2db1130e5f76","resource":{"attester":[{"mode":"legal","party":{"display":"Example Practitioner","reference":"urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"},"time":"2021-10-25T20:16:29-07:00"}],"author":[{"display":"Example Practitioner","reference":"urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"}],"date":"2021-10-25T20:16:29-07:00","encounter":{"display":"Example Encounter","reference":"urn:uuid:5ce5c83a-000f-47d2-941c-039358cc9112"},"id":"17a80a8d-4cf1-4deb-a1fd-2db1130e5f76","resourceType":"Composition","section":[{"entry":[{"reference":"urn:uuid:014a68ec-d691-49e0-b980-91b0d924e570"}],"title":"Active Condition 1"}],"status":"final","subject":{"display":"Example Patient","reference":"urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece"},"text":{"div":"&lt;div xmlns=\\"http://www.w3.org/1999/xhtml\\"&gt;&lt;p&gt;&lt;b&gt;Generated Narrative&lt;/b&gt;&lt;/p&gt;&lt;div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"&gt;&lt;p style=\\"margin-bottom: 0px\\"&gt;Resource \\"17a80a8d-4cf1-4deb-a1fd-2db1130e5f76\\" &lt;/p&gt;&lt;/div&gt;&lt;p&gt;&lt;b&gt;status&lt;/b&gt;: final&lt;/p&gt;&lt;p&gt;&lt;b&gt;type&lt;/b&gt;: Medical records &lt;span style=\\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\\"&gt; (&lt;a href=\\"https://loinc.org/\\"&gt;LOINC&lt;/a&gt;#11503-0)&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;encounter&lt;/b&gt;: &lt;a href=\\"#Encounter_5ce5c83a-000f-47d2-941c-039358cc9112\\"&gt;See above (urn:uuid:5ce5c83a-000f-47d2-941c-039358cc9112: Example Encounter)&lt;/a&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;date&lt;/b&gt;: 2021-10-25T20:16:29-07:00&lt;/p&gt;&lt;p&gt;&lt;b&gt;author&lt;/b&gt;: &lt;a href=\\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\\"&gt;See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: Example Practitioner)&lt;/a&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;title&lt;/b&gt;: Active Conditions&lt;/p&gt;&lt;h3&gt;Attesters&lt;/h3&gt;&lt;table class=\\"grid\\"&gt;&lt;tr&gt;&lt;td&gt;-&lt;/td&gt;&lt;td&gt;&lt;b&gt;Mode&lt;/b&gt;&lt;/td&gt;&lt;td&gt;&lt;b&gt;Time&lt;/b&gt;&lt;/td&gt;&lt;td&gt;&lt;b&gt;Party&lt;/b&gt;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;*&lt;/td&gt;&lt;td&gt;legal&lt;/td&gt;&lt;td&gt;2021-10-25T20:16:29-07:00&lt;/td&gt;&lt;td&gt;&lt;a href=\\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\\"&gt;See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: Example Practitioner)&lt;/a&gt;&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;/div&gt;","status":"generated"},"title":"Active Conditions","type":{"coding":[{"code":"11503-0","system":"http://loinc.org"}],"text":"Medical records"}}},{"fullUrl":"urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc","resource":{"id":"0820c16d-91de-4dfa-a3a6-f140a516a9bc","meta":{"lastUpdated":"2013-05-05T16:13:03Z"},"name":[{"family":"Hancock","given":["John"]}],"resourceType":"Practitioner","text":{"div":"&lt;div xmlns=\\"http://www.w3.org/1999/xhtml\\"&gt;&lt;p&gt;&lt;b&gt;Generated Narrative&lt;/b&gt;&lt;/p&gt;&lt;div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"&gt;&lt;p style=\\"margin-bottom: 0px\\"&gt;Resource \\"0820c16d-91de-4dfa-a3a6-f140a516a9bc\\" Updated \\"2013-05-05T16:13:03Z\\" &lt;/p&gt;&lt;/div&gt;&lt;p&gt;&lt;b&gt;name&lt;/b&gt;: John Hancock &lt;/p&gt;&lt;/div&gt;","status":"generated"}}},{"fullUrl":"urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece","resource":{"active":true,"id":"970af6c9-5bbd-4067-b6c1-d9b2c823aece","name":[{"family":"Patient","given":["CDEX Example"],"text":"CDEX Example Patient"}],"resourceType":"Patient","text":{"div":"&lt;div xmlns=\\"http://www.w3.org/1999/xhtml\\"&gt;&lt;p&gt;&lt;b&gt;Generated Narrative&lt;/b&gt;&lt;/p&gt;&lt;div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"&gt;&lt;p style=\\"margin-bottom: 0px\\"&gt;Resource \\"970af6c9-5bbd-4067-b6c1-d9b2c823aece\\" &lt;/p&gt;&lt;/div&gt;&lt;p&gt;&lt;b&gt;active&lt;/b&gt;: true&lt;/p&gt;&lt;p&gt;&lt;b&gt;name&lt;/b&gt;: CDEX Example Patient&lt;/p&gt;&lt;/div&gt;","status":"generated"}}},{"fullUrl":"urn:uuid:014a68ec-d691-49e0-b980-91b0d924e570","resource":{"asserter":{"reference":"urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"},"category":[{"coding":[{"code":"55607006","display":"Problem","system":"http://snomed.info/sct"},{"code":"75326-9","display":"Problem","system":"http://loinc.org"}]}],"clinicalStatus":{"coding":[{"code":"active","system":"http://terminology.hl7.org/CodeSystem/condition-clinical"}]},"code":{"coding":[{"code":"44054006","display":"Type 2 Diabetes Mellitus","system":"http://snomed.info/sct"}]},"id":"014a68ec-d691-49e0-b980-91b0d924e570","identifier":[{"system":"urn:oid:1.3.6.1.4.1.22812.4.111.0.4.1.2.1","value":"1"}],"onsetDateTime":"2006","resourceType":"Condition","subject":{"reference":"urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece"},"text":{"div":"&lt;div xmlns=\\"http://www.w3.org/1999/xhtml\\"&gt;&lt;p&gt;&lt;b&gt;Generated Narrative&lt;/b&gt;&lt;/p&gt;&lt;div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"&gt;&lt;p style=\\"margin-bottom: 0px\\"&gt;Resource \\"014a68ec-d691-49e0-b980-91b0d924e570\\" &lt;/p&gt;&lt;/div&gt;&lt;p&gt;&lt;b&gt;identifier&lt;/b&gt;: id: 1&lt;/p&gt;&lt;p&gt;&lt;b&gt;clinicalStatus&lt;/b&gt;: Active &lt;span style=\\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\\"&gt; (&lt;a href=\\"http://terminology.hl7.org/3.0.0/CodeSystem-condition-clinical.html\\"&gt;Condition Clinical Status Codes&lt;/a&gt;#active)&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;category&lt;/b&gt;: Problem &lt;span style=\\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\\"&gt; (&lt;a href=\\"https://browser.ihtsdotools.org/\\"&gt;SNOMED CT&lt;/a&gt;#55607006; &lt;a href=\\"https://loinc.org/\\"&gt;LOINC&lt;/a&gt;#75326-9)&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;code&lt;/b&gt;: Type 2 Diabetes Mellitus &lt;span style=\\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\\"&gt; (&lt;a href=\\"https://browser.ihtsdotools.org/\\"&gt;SNOMED CT&lt;/a&gt;#44054006)&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;subject&lt;/b&gt;: &lt;a href=\\"#Patient_970af6c9-5bbd-4067-b6c1-d9b2c823aece\\"&gt;See above (urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece)&lt;/a&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;onset&lt;/b&gt;: 2006-01-01&lt;/p&gt;&lt;p&gt;&lt;b&gt;asserter&lt;/b&gt;: &lt;a href=\\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\\"&gt;See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc)&lt;/a&gt;&lt;/p&gt;&lt;/div&gt;","status":"generated"}}},{"fullUrl":"urn:uuid:5ce5c83a-000f-47d2-941c-039358cc9112","resource":{"class":{"code":"EMER","system":"http://terminology.hl7.org/CodeSystem/v3-ActCode"},"id":"5ce5c83a-000f-47d2-941c-039358cc9112","participant":[{"individual":{"display":"John Hancock","reference":"urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"}}],"period":{"end":"2021-10-25T20:16:29-07:00","start":"2021-10-25T20:10:29-07:00"},"resourceType":"Encounter","serviceProvider":{"display":"CDEX Example Organization","reference":"urn:uuid:e37f004b-dc10-422b-b833-cdaa10a055a3"},"status":"finished","subject":{"display":"CDEX Example Patient","reference":"urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece"},"text":{"div":"&lt;div xmlns=\\"http://www.w3.org/1999/xhtml\\"&gt;&lt;p&gt;&lt;b&gt;Generated Narrative&lt;/b&gt;&lt;/p&gt;&lt;div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"&gt;&lt;p style=\\"margin-bottom: 0px\\"&gt;Resource \\"5ce5c83a-000f-47d2-941c-039358cc9112\\" &lt;/p&gt;&lt;/div&gt;&lt;p&gt;&lt;b&gt;status&lt;/b&gt;: finished&lt;/p&gt;&lt;p&gt;&lt;b&gt;class&lt;/b&gt;: emergency (Details: http://terminology.hl7.org/CodeSystem/v3-ActCode code EMER = \'emergency\', stated as \'null\')&lt;/p&gt;&lt;p&gt;&lt;b&gt;type&lt;/b&gt;: Unknown (qualifier value) &lt;span style=\\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\\"&gt; (&lt;a href=\\"https://browser.ihtsdotools.org/\\"&gt;SNOMED CT&lt;/a&gt;#261665006)&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;subject&lt;/b&gt;: &lt;a href=\\"#Patient_970af6c9-5bbd-4067-b6c1-d9b2c823aece\\"&gt;See above (urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece: CDEX Example Patient)&lt;/a&gt;&lt;/p&gt;&lt;h3&gt;Participants&lt;/h3&gt;&lt;table class=\\"grid\\"&gt;&lt;tr&gt;&lt;td&gt;-&lt;/td&gt;&lt;td&gt;&lt;b&gt;Individual&lt;/b&gt;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;*&lt;/td&gt;&lt;td&gt;&lt;a href=\\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\\"&gt;See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: John Hancock)&lt;/a&gt;&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;p&gt;&lt;b&gt;period&lt;/b&gt;: 2021-10-25T20:10:29-07:00 --&gt; 2021-10-25T20:16:29-07:00&lt;/p&gt;&lt;p&gt;&lt;b&gt;serviceProvider&lt;/b&gt;: &lt;a href=\\"#Organization_e37f004b-dc10-422b-b833-cdaa10a055a3\\"&gt;See above (urn:uuid:e37f004b-dc10-422b-b833-cdaa10a055a3: CDEX Example Organization)&lt;/a&gt;&lt;/p&gt;&lt;/div&gt;","status":"generated"},"type":[{"coding":[{"code":"261665006","display":"Unknown (qualifier value)","system":"http://snomed.info/sct"}],"text":"Unknown (qualifier value)"}]}},{"fullUrl":"urn:uuid:e37f004b-dc10-422b-b833-cdaa10a055a3","resource":{"active":true,"address":[{"city":"Boston","country":"USA","line":["1 CDEX Lane"],"postalCode":"01002","state":"MA"}],"id":"e37f004b-dc10-422b-b833-cdaa10a055a3","name":"CDEX Example Organization","resourceType":"Organization","telecom":[{"system":"phone","value":"(+1) 555-555-5555"},{"system":"email","value":"customer-service@example.org"}],"text":{"div":"&lt;div xmlns=\\"http://www.w3.org/1999/xhtml\\"&gt;&lt;p&gt;&lt;b&gt;Generated Narrative&lt;/b&gt;&lt;/p&gt;&lt;div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"&gt;&lt;p style=\\"margin-bottom: 0px\\"&gt;Resource \\"e37f004b-dc10-422b-b833-cdaa10a055a3\\" &lt;/p&gt;&lt;/div&gt;&lt;p&gt;&lt;b&gt;active&lt;/b&gt;: true&lt;/p&gt;&lt;p&gt;&lt;b&gt;name&lt;/b&gt;: CDEX Example Organization&lt;/p&gt;&lt;p&gt;&lt;b&gt;telecom&lt;/b&gt;: ph: (+1) 555-555-5555, &lt;a href=\\"mailto:customer-service@example.org\\"&gt;customer-service@example.org&lt;/a&gt;&lt;/p&gt;&lt;p&gt;&lt;b&gt;address&lt;/b&gt;: 1 CDEX Lane Boston MA 01002 USA &lt;/p&gt;&lt;/div&gt;","status":"generated"}}}],"identifier":{"system":"urn:ietf:rfc:3986","value":"urn:uuid:c173535e-135e-48e3-ab64-38bacc68dba8"},"resourceType":"Bundle","timestamp":"2021-10-25T20:16:29-07:00","type":"document"}'

</pre>



**3. Transform canonicalize Bundle to a base64 format using the Base64-URL algorithm.**


```python
from base64 import urlsafe_b64encode
recd_b64_canonical_bundle  = urlsafe_b64encode(canonical_bundle).decode()
recd_b64_canonical_bundle = recd_b64_canonical_bundle.replace("=","")  #remove padding since decode package doesn't use them
recd_b64_canonical_bundle
```




<pre style="border:0; overflow-wrap:break-word;">

'eyJlbnRyeSI6W3siZnVsbFVybCI6InVybjp1dWlkOjE3YTgwYThkLTRjZjEtNGRlYi1hMWZkLTJkYjExMzBlNWY3NiIsInJlc291cmNlIjp7ImF0dGVzdGVyIjpbeyJtb2RlIjoibGVnYWwiLCJwYXJ0eSI6eyJkaXNwbGF5IjoiRXhhbXBsZSBQcmFjdGl0aW9uZXIiLCJyZWZlcmVuY2UiOiJ1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMifSwidGltZSI6IjIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDAifV0sImF1dGhvciI6W3siZGlzcGxheSI6IkV4YW1wbGUgUHJhY3RpdGlvbmVyIiwicmVmZXJlbmNlIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIn1dLCJkYXRlIjoiMjAyMS0xMC0yNVQyMDoxNjoyOS0wNzowMCIsImVuY291bnRlciI6eyJkaXNwbGF5IjoiRXhhbXBsZSBFbmNvdW50ZXIiLCJyZWZlcmVuY2UiOiJ1cm46dXVpZDo1Y2U1YzgzYS0wMDBmLTQ3ZDItOTQxYy0wMzkzNThjYzkxMTIifSwiaWQiOiIxN2E4MGE4ZC00Y2YxLTRkZWItYTFmZC0yZGIxMTMwZTVmNzYiLCJyZXNvdXJjZVR5cGUiOiJDb21wb3NpdGlvbiIsInNlY3Rpb24iOlt7ImVudHJ5IjpbeyJyZWZlcmVuY2UiOiJ1cm46dXVpZDowMTRhNjhlYy1kNjkxLTQ5ZTAtYjk4MC05MWIwZDkyNGU1NzAifV0sInRpdGxlIjoiQWN0aXZlIENvbmRpdGlvbiAxIn1dLCJzdGF0dXMiOiJmaW5hbCIsInN1YmplY3QiOnsiZGlzcGxheSI6IkV4YW1wbGUgUGF0aWVudCIsInJlZmVyZW5jZSI6InVybjp1dWlkOjk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZSJ9LCJ0ZXh0Ijp7ImRpdiI6IjxkaXYgeG1sbnM9XCJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hodG1sXCI-PHA-PGI-R2VuZXJhdGVkIE5hcnJhdGl2ZTwvYj48L3A-PGRpdiBzdHlsZT1cImRpc3BsYXk6IGlubGluZS1ibG9jazsgYmFja2dyb3VuZC1jb2xvcjogI2Q5ZTBlNzsgcGFkZGluZzogNnB4OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQgIzhkYTFiNDsgYm9yZGVyLXJhZGl1czogNXB4OyBsaW5lLWhlaWdodDogNjAlXCI-PHAgc3R5bGU9XCJtYXJnaW4tYm90dG9tOiAwcHhcIj5SZXNvdXJjZSBcIjE3YTgwYThkLTRjZjEtNGRlYi1hMWZkLTJkYjExMzBlNWY3NlwiIDwvcD48L2Rpdj48cD48Yj5zdGF0dXM8L2I-OiBmaW5hbDwvcD48cD48Yj50eXBlPC9iPjogTWVkaWNhbCByZWNvcmRzIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vbG9pbmMub3JnL1wiPkxPSU5DPC9hPiMxMTUwMy0wKTwvc3Bhbj48L3A-PHA-PGI-ZW5jb3VudGVyPC9iPjogPGEgaHJlZj1cIiNFbmNvdW50ZXJfNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyXCI-U2VlIGFib3ZlICh1cm46dXVpZDo1Y2U1YzgzYS0wMDBmLTQ3ZDItOTQxYy0wMzkzNThjYzkxMTI6IEV4YW1wbGUgRW5jb3VudGVyKTwvYT48L3A-PHA-PGI-ZGF0ZTwvYj46IDIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDA8L3A-PHA-PGI-YXV0aG9yPC9iPjogPGEgaHJlZj1cIiNQcmFjdGl0aW9uZXJfMDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjXCI-U2VlIGFib3ZlICh1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmM6IEV4YW1wbGUgUHJhY3RpdGlvbmVyKTwvYT48L3A-PHA-PGI-dGl0bGU8L2I-OiBBY3RpdmUgQ29uZGl0aW9uczwvcD48aDM-QXR0ZXN0ZXJzPC9oMz48dGFibGUgY2xhc3M9XCJncmlkXCI-PHRyPjx0ZD4tPC90ZD48dGQ-PGI-TW9kZTwvYj48L3RkPjx0ZD48Yj5UaW1lPC9iPjwvdGQ-PHRkPjxiPlBhcnR5PC9iPjwvdGQ-PC90cj48dHI-PHRkPio8L3RkPjx0ZD5sZWdhbDwvdGQ-PHRkPjIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDA8L3RkPjx0ZD48YSBocmVmPVwiI1ByYWN0aXRpb25lcl8wODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmNcIj5TZWUgYWJvdmUgKHVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYzogRXhhbXBsZSBQcmFjdGl0aW9uZXIpPC9hPjwvdGQ-PC90cj48L3RhYmxlPjwvZGl2PiIsInN0YXR1cyI6ImdlbmVyYXRlZCJ9LCJ0aXRsZSI6IkFjdGl2ZSBDb25kaXRpb25zIiwidHlwZSI6eyJjb2RpbmciOlt7ImNvZGUiOiIxMTUwMy0wIiwic3lzdGVtIjoiaHR0cDovL2xvaW5jLm9yZyJ9XSwidGV4dCI6Ik1lZGljYWwgcmVjb3JkcyJ9fX0seyJmdWxsVXJsIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIiwicmVzb3VyY2UiOnsiaWQiOiIwODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMiLCJtZXRhIjp7Imxhc3RVcGRhdGVkIjoiMjAxMy0wNS0wNVQxNjoxMzowM1oifSwibmFtZSI6W3siZmFtaWx5IjoiSGFuY29jayIsImdpdmVuIjpbIkpvaG4iXX1dLCJyZXNvdXJjZVR5cGUiOiJQcmFjdGl0aW9uZXIiLCJ0ZXh0Ijp7ImRpdiI6IjxkaXYgeG1sbnM9XCJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hodG1sXCI-PHA-PGI-R2VuZXJhdGVkIE5hcnJhdGl2ZTwvYj48L3A-PGRpdiBzdHlsZT1cImRpc3BsYXk6IGlubGluZS1ibG9jazsgYmFja2dyb3VuZC1jb2xvcjogI2Q5ZTBlNzsgcGFkZGluZzogNnB4OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQgIzhkYTFiNDsgYm9yZGVyLXJhZGl1czogNXB4OyBsaW5lLWhlaWdodDogNjAlXCI-PHAgc3R5bGU9XCJtYXJnaW4tYm90dG9tOiAwcHhcIj5SZXNvdXJjZSBcIjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliY1wiIFVwZGF0ZWQgXCIyMDEzLTA1LTA1VDE2OjEzOjAzWlwiIDwvcD48L2Rpdj48cD48Yj5uYW1lPC9iPjogSm9obiBIYW5jb2NrIDwvcD48L2Rpdj4iLCJzdGF0dXMiOiJnZW5lcmF0ZWQifX19LHsiZnVsbFVybCI6InVybjp1dWlkOjk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZSIsInJlc291cmNlIjp7ImFjdGl2ZSI6dHJ1ZSwiaWQiOiI5NzBhZjZjOS01YmJkLTQwNjctYjZjMS1kOWIyYzgyM2FlY2UiLCJuYW1lIjpbeyJmYW1pbHkiOiJQYXRpZW50IiwiZ2l2ZW4iOlsiQ0RFWCBFeGFtcGxlIl0sInRleHQiOiJDREVYIEV4YW1wbGUgUGF0aWVudCJ9XSwicmVzb3VyY2VUeXBlIjoiUGF0aWVudCIsInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiOTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlXCIgPC9wPjwvZGl2PjxwPjxiPmFjdGl2ZTwvYj46IHRydWU8L3A-PHA-PGI-bmFtZTwvYj46IENERVggRXhhbXBsZSBQYXRpZW50PC9wPjwvZGl2PiIsInN0YXR1cyI6ImdlbmVyYXRlZCJ9fX0seyJmdWxsVXJsIjoidXJuOnV1aWQ6MDE0YTY4ZWMtZDY5MS00OWUwLWI5ODAtOTFiMGQ5MjRlNTcwIiwicmVzb3VyY2UiOnsiYXNzZXJ0ZXIiOnsicmVmZXJlbmNlIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIn0sImNhdGVnb3J5IjpbeyJjb2RpbmciOlt7ImNvZGUiOiI1NTYwNzAwNiIsImRpc3BsYXkiOiJQcm9ibGVtIiwic3lzdGVtIjoiaHR0cDovL3Nub21lZC5pbmZvL3NjdCJ9LHsiY29kZSI6Ijc1MzI2LTkiLCJkaXNwbGF5IjoiUHJvYmxlbSIsInN5c3RlbSI6Imh0dHA6Ly9sb2luYy5vcmcifV19XSwiY2xpbmljYWxTdGF0dXMiOnsiY29kaW5nIjpbeyJjb2RlIjoiYWN0aXZlIiwic3lzdGVtIjoiaHR0cDovL3Rlcm1pbm9sb2d5LmhsNy5vcmcvQ29kZVN5c3RlbS9jb25kaXRpb24tY2xpbmljYWwifV19LCJjb2RlIjp7ImNvZGluZyI6W3siY29kZSI6IjQ0MDU0MDA2IiwiZGlzcGxheSI6IlR5cGUgMiBEaWFiZXRlcyBNZWxsaXR1cyIsInN5c3RlbSI6Imh0dHA6Ly9zbm9tZWQuaW5mby9zY3QifV19LCJpZCI6IjAxNGE2OGVjLWQ2OTEtNDllMC1iOTgwLTkxYjBkOTI0ZTU3MCIsImlkZW50aWZpZXIiOlt7InN5c3RlbSI6InVybjpvaWQ6MS4zLjYuMS40LjEuMjI4MTIuNC4xMTEuMC40LjEuMi4xIiwidmFsdWUiOiIxIn1dLCJvbnNldERhdGVUaW1lIjoiMjAwNiIsInJlc291cmNlVHlwZSI6IkNvbmRpdGlvbiIsInN1YmplY3QiOnsicmVmZXJlbmNlIjoidXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlIn0sInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiMDE0YTY4ZWMtZDY5MS00OWUwLWI5ODAtOTFiMGQ5MjRlNTcwXCIgPC9wPjwvZGl2PjxwPjxiPmlkZW50aWZpZXI8L2I-OiBpZDogMTwvcD48cD48Yj5jbGluaWNhbFN0YXR1czwvYj46IEFjdGl2ZSA8c3BhbiBzdHlsZT1cImJhY2tncm91bmQ6IExpZ2h0R29sZGVuUm9kWWVsbG93OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQga2hha2lcIj4gKDxhIGhyZWY9XCJodHRwOi8vdGVybWlub2xvZ3kuaGw3Lm9yZy8zLjAuMC9Db2RlU3lzdGVtLWNvbmRpdGlvbi1jbGluaWNhbC5odG1sXCI-Q29uZGl0aW9uIENsaW5pY2FsIFN0YXR1cyBDb2RlczwvYT4jYWN0aXZlKTwvc3Bhbj48L3A-PHA-PGI-Y2F0ZWdvcnk8L2I-OiBQcm9ibGVtIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vYnJvd3Nlci5paHRzZG90b29scy5vcmcvXCI-U05PTUVEIENUPC9hPiM1NTYwNzAwNjsgPGEgaHJlZj1cImh0dHBzOi8vbG9pbmMub3JnL1wiPkxPSU5DPC9hPiM3NTMyNi05KTwvc3Bhbj48L3A-PHA-PGI-Y29kZTwvYj46IFR5cGUgMiBEaWFiZXRlcyBNZWxsaXR1cyA8c3BhbiBzdHlsZT1cImJhY2tncm91bmQ6IExpZ2h0R29sZGVuUm9kWWVsbG93OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQga2hha2lcIj4gKDxhIGhyZWY9XCJodHRwczovL2Jyb3dzZXIuaWh0c2RvdG9vbHMub3JnL1wiPlNOT01FRCBDVDwvYT4jNDQwNTQwMDYpPC9zcGFuPjwvcD48cD48Yj5zdWJqZWN0PC9iPjogPGEgaHJlZj1cIiNQYXRpZW50Xzk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZVwiPlNlZSBhYm92ZSAodXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlKTwvYT48L3A-PHA-PGI-b25zZXQ8L2I-OiAyMDA2LTAxLTAxPC9wPjxwPjxiPmFzc2VydGVyPC9iPjogPGEgaHJlZj1cIiNQcmFjdGl0aW9uZXJfMDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjXCI-U2VlIGFib3ZlICh1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMpPC9hPjwvcD48L2Rpdj4iLCJzdGF0dXMiOiJnZW5lcmF0ZWQifX19LHsiZnVsbFVybCI6InVybjp1dWlkOjVjZTVjODNhLTAwMGYtNDdkMi05NDFjLTAzOTM1OGNjOTExMiIsInJlc291cmNlIjp7ImNsYXNzIjp7ImNvZGUiOiJFTUVSIiwic3lzdGVtIjoiaHR0cDovL3Rlcm1pbm9sb2d5LmhsNy5vcmcvQ29kZVN5c3RlbS92My1BY3RDb2RlIn0sImlkIjoiNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyIiwicGFydGljaXBhbnQiOlt7ImluZGl2aWR1YWwiOnsiZGlzcGxheSI6IkpvaG4gSGFuY29jayIsInJlZmVyZW5jZSI6InVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYyJ9fV0sInBlcmlvZCI6eyJlbmQiOiIyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwIiwic3RhcnQiOiIyMDIxLTEwLTI1VDIwOjEwOjI5LTA3OjAwIn0sInJlc291cmNlVHlwZSI6IkVuY291bnRlciIsInNlcnZpY2VQcm92aWRlciI6eyJkaXNwbGF5IjoiQ0RFWCBFeGFtcGxlIE9yZ2FuaXphdGlvbiIsInJlZmVyZW5jZSI6InVybjp1dWlkOmUzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhMyJ9LCJzdGF0dXMiOiJmaW5pc2hlZCIsInN1YmplY3QiOnsiZGlzcGxheSI6IkNERVggRXhhbXBsZSBQYXRpZW50IiwicmVmZXJlbmNlIjoidXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlIn0sInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyXCIgPC9wPjwvZGl2PjxwPjxiPnN0YXR1czwvYj46IGZpbmlzaGVkPC9wPjxwPjxiPmNsYXNzPC9iPjogZW1lcmdlbmN5IChEZXRhaWxzOiBodHRwOi8vdGVybWlub2xvZ3kuaGw3Lm9yZy9Db2RlU3lzdGVtL3YzLUFjdENvZGUgY29kZSBFTUVSID0gJ2VtZXJnZW5jeScsIHN0YXRlZCBhcyAnbnVsbCcpPC9wPjxwPjxiPnR5cGU8L2I-OiBVbmtub3duIChxdWFsaWZpZXIgdmFsdWUpIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vYnJvd3Nlci5paHRzZG90b29scy5vcmcvXCI-U05PTUVEIENUPC9hPiMyNjE2NjUwMDYpPC9zcGFuPjwvcD48cD48Yj5zdWJqZWN0PC9iPjogPGEgaHJlZj1cIiNQYXRpZW50Xzk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZVwiPlNlZSBhYm92ZSAodXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlOiBDREVYIEV4YW1wbGUgUGF0aWVudCk8L2E-PC9wPjxoMz5QYXJ0aWNpcGFudHM8L2gzPjx0YWJsZSBjbGFzcz1cImdyaWRcIj48dHI-PHRkPi08L3RkPjx0ZD48Yj5JbmRpdmlkdWFsPC9iPjwvdGQ-PC90cj48dHI-PHRkPio8L3RkPjx0ZD48YSBocmVmPVwiI1ByYWN0aXRpb25lcl8wODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmNcIj5TZWUgYWJvdmUgKHVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYzogSm9obiBIYW5jb2NrKTwvYT48L3RkPjwvdHI-PC90YWJsZT48cD48Yj5wZXJpb2Q8L2I-OiAyMDIxLTEwLTI1VDIwOjEwOjI5LTA3OjAwIC0tJmd0OyAyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwPC9wPjxwPjxiPnNlcnZpY2VQcm92aWRlcjwvYj46IDxhIGhyZWY9XCIjT3JnYW5pemF0aW9uX2UzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhM1wiPlNlZSBhYm92ZSAodXJuOnV1aWQ6ZTM3ZjAwNGItZGMxMC00MjJiLWI4MzMtY2RhYTEwYTA1NWEzOiBDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uKTwvYT48L3A-PC9kaXY-Iiwic3RhdHVzIjoiZ2VuZXJhdGVkIn0sInR5cGUiOlt7ImNvZGluZyI6W3siY29kZSI6IjI2MTY2NTAwNiIsImRpc3BsYXkiOiJVbmtub3duIChxdWFsaWZpZXIgdmFsdWUpIiwic3lzdGVtIjoiaHR0cDovL3Nub21lZC5pbmZvL3NjdCJ9XSwidGV4dCI6IlVua25vd24gKHF1YWxpZmllciB2YWx1ZSkifV19fSx7ImZ1bGxVcmwiOiJ1cm46dXVpZDplMzdmMDA0Yi1kYzEwLTQyMmItYjgzMy1jZGFhMTBhMDU1YTMiLCJyZXNvdXJjZSI6eyJhY3RpdmUiOnRydWUsImFkZHJlc3MiOlt7ImNpdHkiOiJCb3N0b24iLCJjb3VudHJ5IjoiVVNBIiwibGluZSI6WyIxIENERVggTGFuZSJdLCJwb3N0YWxDb2RlIjoiMDEwMDIiLCJzdGF0ZSI6Ik1BIn1dLCJpZCI6ImUzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhMyIsIm5hbWUiOiJDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uIiwicmVzb3VyY2VUeXBlIjoiT3JnYW5pemF0aW9uIiwidGVsZWNvbSI6W3sic3lzdGVtIjoicGhvbmUiLCJ2YWx1ZSI6IigrMSkgNTU1LTU1NS01NTU1In0seyJzeXN0ZW0iOiJlbWFpbCIsInZhbHVlIjoiY3VzdG9tZXItc2VydmljZUBleGFtcGxlLm9yZyJ9XSwidGV4dCI6eyJkaXYiOiI8ZGl2IHhtbG5zPVwiaHR0cDovL3d3dy53My5vcmcvMTk5OS94aHRtbFwiPjxwPjxiPkdlbmVyYXRlZCBOYXJyYXRpdmU8L2I-PC9wPjxkaXYgc3R5bGU9XCJkaXNwbGF5OiBpbmxpbmUtYmxvY2s7IGJhY2tncm91bmQtY29sb3I6ICNkOWUwZTc7IHBhZGRpbmc6IDZweDsgbWFyZ2luOiA0cHg7IGJvcmRlcjogMXB4IHNvbGlkICM4ZGExYjQ7IGJvcmRlci1yYWRpdXM6IDVweDsgbGluZS1oZWlnaHQ6IDYwJVwiPjxwIHN0eWxlPVwibWFyZ2luLWJvdHRvbTogMHB4XCI-UmVzb3VyY2UgXCJlMzdmMDA0Yi1kYzEwLTQyMmItYjgzMy1jZGFhMTBhMDU1YTNcIiA8L3A-PC9kaXY-PHA-PGI-YWN0aXZlPC9iPjogdHJ1ZTwvcD48cD48Yj5uYW1lPC9iPjogQ0RFWCBFeGFtcGxlIE9yZ2FuaXphdGlvbjwvcD48cD48Yj50ZWxlY29tPC9iPjogcGg6ICgrMSkgNTU1LTU1NS01NTU1LCA8YSBocmVmPVwibWFpbHRvOmN1c3RvbWVyLXNlcnZpY2VAZXhhbXBsZS5vcmdcIj5jdXN0b21lci1zZXJ2aWNlQGV4YW1wbGUub3JnPC9hPjwvcD48cD48Yj5hZGRyZXNzPC9iPjogMSBDREVYIExhbmUgQm9zdG9uIE1BIDAxMDAyIFVTQSA8L3A-PC9kaXY-Iiwic3RhdHVzIjoiZ2VuZXJhdGVkIn19fV0sImlkZW50aWZpZXIiOnsic3lzdGVtIjoidXJuOmlldGY6cmZjOjM5ODYiLCJ2YWx1ZSI6InVybjp1dWlkOmMxNzM1MzVlLTEzNWUtNDhlMy1hYjY0LTM4YmFjYzY4ZGJhOCJ9LCJyZXNvdXJjZVR5cGUiOiJCdW5kbGUiLCJ0aW1lc3RhbXAiOiIyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwIiwidHlwZSI6ImRvY3VtZW50In0'

</pre>



**4. Get the base64 encoded JWS  from the `Bundle.signature.data`  element**


```python
recd_b64_jws = recd_signature['data']
recd_b64_jws
```




<pre style="border:0; overflow-wrap:break-word;">
'ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXQwZVNJNklsSlRJaXdpZEhsd0lqb2lTbGRVSWl3aWVEVmpJanBiSWsxSlNVVXpla05EUVRCbFowRjNTVUpCWjBsS1FVOUxSbGwyVFhkU0szbFJUVUV3UjBOVGNVZFRTV0l6UkZGRlFrTjNWVUZOU1VkT1RWRnpkME5SV1VSV1VWRkhSWGRLVmxWNlJWUk5Ra1ZIUVRGVlJVTkJkMHRSTWtaellWZGFkbU50TlhCWlZFVlRUVUpCUjBFeFZVVkNkM2RLVlRKR01XTXlSbk5oV0ZKMlRWSlZkMFYzV1VSV1VWRkxSRUY0U1ZwWFJuTmtSMmhzVWtkR01GbFVSWGhHZWtGV1FtZE9Wa0pCVFUxRWExWjVZVmROWjFOSFJtaGplWGRuVWtaYVRrMVRWWGRKZDFsS1MyOWFTV2gyWTA1QlVXdENSbWhhYkdGSFJtaGpNRUp2V2xkR2MyUkhhR3hhUjBZd1dWUkZkV0l6U201TlFqUllSRlJKZUUxVVFYbE9la1V6VGtSSmQwNUdiMWhFVkVsNVRWUkJlVTFxUlROT1JFbDNUa1p2ZDJkWk1IaERla0ZLUW1kT1ZrSkJXVlJCYkZaVVRWSk5kMFZSV1VSV1VWRkpSRUZ3UkZsWGVIQmFiVGw1WW0xc2FFMVNTWGRGUVZsRVZsRlJTRVJCYkZSWldGWjZXVmQ0Y0dSSE9IaEdWRUZVUW1kT1ZrSkJiMDFFUldoc1dWZDRNR0ZIVmtWWldGSm9UVlJGV0UxQ1ZVZEJNVlZGUVhkM1QxSllTbkJaZVVKSldWZEdla3hEUWtWV2F6QjRTbFJCYWtKbmEzRm9hMmxIT1hjd1FrTlJSVmRHYlZadldWZEdlbEZIYUd4WlYzZ3dZVWRXYTFsWVVtaE5VelYyWTIxamQyZG5SMmxOUVRCSFExTnhSMU5KWWpORVVVVkNRVkZWUVVFMFNVSnFkMEYzWjJkSFMwRnZTVUpuVVVSd1MyTlRhMjlCVFRaelZ6SXhLM1pYVkdWSlZrOUhlREV3VFZkaGMxRjVOMVpJYVdRMmVubHhXRUZDVFN0NmJtWkNibGhsYm5sVk1Hb3hSbFIyVUcxU1prOUViMDlFV0ZaMVVGVjNSRzl0YUVOSWFDdGlZMnhYT1V0Tk1tODFOak5qZUZKTFJYWkNibUZJY25OcWR6VjVUbTE0VHpWWmFrVlNZbWgwU0dSUlpYRnJkR1IzTTFaWlJWSlNPVWh2ZUV4UE0wWnJjM3BTTWpreVNGUkNOSGhYTTNsWGJGWXpaMVJyVFZGdmVsQlRZMHBMU0ROaVJ6aFFjWEUyUVZsUVNqZERORmxDU1d4VlUyUkNUVlpzTTNGdVpVVm1aemRtZFhocFJtWlliMlprVkZadE4zSk5hV2xITjFnNWVqUXpVR1pwYkhGaFpXbHpabTEwVW5oQmJGSjNSVTVZY2tnelQzWlBSRkI1VERCeVZHNUhPRU56WWtGWVdWWkpUVzFrWkVobE5GcEdPWEJzYURrMWMybzBjRTFVYUV4MFkwcFlMMjg1V0VoTWFtZzNSVzFhZVdkS1NGZEZVWEUwVUhkR2QxcGtiV0pqWm1oRGJVOXlPRGhJT0VKaVZYSjFMemRXTm5waWMwY3hUakZEVjJ4dVpHeGlWbnB1VENzelNVMVBjamhyV0dGSVkyRnVjV1pqYTJkR1ZqUkZjbTVtYWtaS2NURlBTV0ZCYlhOTmFqZzFlRTFyYW5sWVRIbGpURXd2ZFRWdU1tODJRbWM1TXk5VlVtWnhkVTl2VTBsSFQwTlNNalZFWVZwNmNIY3lhek56TjI5Rk9XUk5kMFZYV0hSbVdHZFpkR2d5WW14cWVUVjBSa2d3UjJwd1QydDRNRGRxTjFwVU5VaHVlRzVzYzBOQmQwVkJRV0ZPUVUxRU5IZEVRVmxFVmxJd1ZFSkJWWGRCZDBWQ0wzcEJURUpuVGxaSVVUaEZRa0ZOUTBKbFFYZEpVVmxFVmxJd1VrSkNiM2RIU1VsWFpETmtNMHh0YUd4WlYzZ3dZVWRXYTFsWVVtaGhWelZxVEcxT2RtSlVRVTVDWjJ0eGFHdHBSemwzTUVKQlVYTkdRVUZQUTBGWlJVRkRkVTFWVG5FNVlYa3JLMlUxV1VNM1VVWlBPVFJ5Wm5wNFIxRnVSak5IYTJ4YVRrRlliVWx5TjFCV1IyUnBSMWt5UjFSNEx6bFNkRWhEZDFSTGVtdE1LM2wyUzI5cVpWbzVaRlpMT0hkeVIxWnBVbXRQTDJwVmVWb3JTMk5YVW05clZXcHpOVGx1WTBwSFVrMVRVMUo0ZEdWRFVYVnFkRFJvWmpJckwzRldLMll5YzAxUmRFVnlkMUJGTXpCMlluRlNXVlZPVGs1Q1ZrVlJjR0ZSZUM5aFkwcEVWWFk1ZGpkemFraHBTa1J4V0hkUkszSjZhamsxYVVoQlNXRmxSVWh4Umk5TmN6SXljREppWlZwMWNYWkpVVXRsVFd3cmMzWldjVWgwYVhWNlYyNUdORlUyVmtsdGNHdHlOR0pJYkRkbFoxWTVTRFpzTmxReVUwMXJhalp4UkZVMVpUbE9aekJhYkV4VWRHOXpjMmhDVEcxdmNFWTNaVGRJZVhKVVJVRnRaazlRUzFGbE1FVm5PVVV5ZFhKNmVIRkNkVWMxTkdzMU1FY3lTakJHYVZCelVVcEJhRVpwVGtkM1UyYzBVek5JZVZaRVJ6ZDFaVXRrTUV3NU0zZExUMDVQV1VkMlRVdHBla05JUWl0d1MzWkZUVXB2V2poNU9YVnBRaXRJUmxoamNEbFNZVXB4U2prM1NIQmFWRVYySzJ4cFEzQXlVRk5ZZW1OTE1ISXlOVk5qZVdwR05tUk1iM1ZMTWxOQ016QjRRWFpLT0hSRk5UZzBLMnB4VVRaRFIyVmpWVGxZYW5ac1FXcDFTbVJEY2tSbFZsQnphbXR1TjA5UVdFY3JPRmhhVlRkNmNVaGFUbTFZV0RGWldUUklOWEpuUlVvME9HeHlWWEpRTTBrNFVpSmRmUS4uSkFFVDZBM1c4S1hmT1lPRS1nTTR5ZlNtTjB1TUluc2ozQ3JNVXRRUmNPS1o0VjRJOS1hWnhhdk1YVW51b0l6bktqOXJCaXItTzh0RkNmamJManJrWHY0U1ZWdXVMaUZPVzRZaWdqUllIX0RnNEx1d2lUNzJrWUdvUllWSDE0cnFTVllDT0VCVm5XQVZUMjV4QUowNUx1NXoyWjVKUTVSZXVMSWpYZDhyU1laYnBMYUY4akJ4S1dGQm9fTDJfNlJ0cVRkTm8zT2tSWWd0UDVOZ2l3dE9JeW9XQnctWEJhWEF0RnROZFdDVTE0dk9rX3RKSjBTZzZsWW9qRTg4MXFXVXNpMUJnRldmc3dhMXhKWElhOFhjcEFfLWtkVHZsWWlPMlpKT3FYdXlKdDJfeGpBOUFWNG14M1RtbXhsN3E2eGNneU9sUUJLTEJVV0pVR0VUXzFkZEhkVlY2dUlDXzkzT3lPOUZMX1N6dzNpV0VsR0x0WGVyTGJFSEdsRG1SOE9KVS0tTmFKQ2V5RFZuYllBZUxFa2VTdTZLcGMwS19uclp6dnI4Um4tX25JM0MxVWpYU04yNHRoX3NPa1liUTYzTnNGZ2lmSmx5WTh1TFMtdXU2aldkM1dhZHlkcTdKNmhhWDlCQjl3dEIwYlJXenFZdXR2Q1lsdnlneHpGQUQ5dWk='
</pre>



**5. Base64 decode the encoded JWS**

note the signature is displayed with the parts labeled and separated with line breaks for easier viewing


```python
from base64 import b64decode
recd_jws = b64decode(recd_b64_jws.encode()).decode()
for i,j in enumerate(recd_jws.split('.')):
    print(f'{labels[i]}:')
    print(f'{j}')
    print()
```

<pre style="border:0; overflow-wrap:break-word;">
header:
eyJhbGciOiJSUzI1NiIsImt0eSI6IlJTIiwidHlwIjoiSldUIiwieDVjIjpbIk1JSUUzekNDQTBlZ0F3SUJBZ0lKQU9LRll2TXdSK3lRTUEwR0NTcUdTSWIzRFFFQkN3VUFNSUdOTVFzd0NRWURWUVFHRXdKVlV6RVRNQkVHQTFVRUNBd0tRMkZzYVdadmNtNXBZVEVTTUJBR0ExVUVCd3dKVTJGMWMyRnNhWFJ2TVJVd0V3WURWUVFLREF4SVpXRnNkR2hsUkdGMFlURXhGekFWQmdOVkJBTU1Ea1Z5YVdNZ1NHRmhjeXdnUkZaTk1TVXdJd1lKS29aSWh2Y05BUWtCRmhabGFHRmhjMEJvWldGc2RHaGxaR0YwWVRFdWIzSm5NQjRYRFRJeE1UQXlOekUzTkRJd05Gb1hEVEl5TVRBeU1qRTNOREl3TkZvd2dZMHhDekFKQmdOVkJBWVRBbFZUTVJNd0VRWURWUVFJREFwRFlXeHBabTl5Ym1saE1SSXdFQVlEVlFRSERBbFRZWFZ6WVd4cGRHOHhGVEFUQmdOVkJBb01ERWhsWVd4MGFHVkVZWFJoTVRFWE1CVUdBMVVFQXd3T1JYSnBZeUJJWVdGekxDQkVWazB4SlRBakJna3Foa2lHOXcwQkNRRVdGbVZvWVdGelFHaGxZV3gwYUdWa1lYUmhNUzV2Y21jd2dnR2lNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUJqd0F3Z2dHS0FvSUJnUURwS2NTa29BTTZzVzIxK3ZXVGVJVk9HeDEwTVdhc1F5N1ZIaWQ2enlxWEFCTSt6bmZCblhlbnlVMGoxRlR2UG1SZk9Eb09EWFZ1UFV3RG9taENIaCtiY2xXOUtNMm81NjNjeFJLRXZCbmFIcnNqdzV5Tm14TzVZakVSYmh0SGRRZXFrdGR3M1ZZRVJSOUhveExPM0Zrc3pSMjkySFRCNHhXM3lXbFYzZ1RrTVFvelBTY0pLSDNiRzhQcXE2QVlQSjdDNFlCSWxVU2RCTVZsM3FuZUVmZzdmdXhpRmZYb2ZkVFZtN3JNaWlHN1g5ejQzUGZpbHFhZWlzZm10UnhBbFJ3RU5YckgzT3ZPRFB5TDByVG5HOENzYkFYWVZJTW1kZEhlNFpGOXBsaDk1c2o0cE1UaEx0Y0pYL285WEhMamg3RW1aeWdKSFdFUXE0UHdGd1pkbWJjZmhDbU9yODhIOEJiVXJ1LzdWNnpic0cxTjFDV2xuZGxiVnpuTCszSU1PcjhrWGFIY2FucWZja2dGVjRFcm5makZKcTFPSWFBbXNNajg1eE1ranlYTHljTEwvdTVuMm82Qmc5My9VUmZxdU9vU0lHT0NSMjVEYVp6cHcyazNzN29FOWRNd0VXWHRmWGdZdGgyYmxqeTV0RkgwR2pwT2t4MDdqN1pUNUhueG5sc0NBd0VBQWFOQU1ENHdEQVlEVlIwVEJBVXdBd0VCL3pBTEJnTlZIUThFQkFNQ0JlQXdJUVlEVlIwUkJCb3dHSUlXZDNkM0xtaGxZV3gwYUdWa1lYUmhhVzVqTG1OdmJUQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FZRUFDdU1VTnE5YXkrK2U1WUM3UUZPOTRyZnp4R1FuRjNHa2xaTkFYbUlyN1BWR2RpR1kyR1R4LzlSdEhDd1RLemtMK3l2S29qZVo5ZFZLOHdyR1ZpUmtPL2pVeVorS2NXUm9rVWpzNTluY0pHUk1TU1J4dGVDUXVqdDRoZjIrL3FWK2Yyc01RdEVyd1BFMzB2YnFSWVVOTk5CVkVRcGFReC9hY0pEVXY5djdzakhpSkRxWHdRK3J6ajk1aUhBSWFlRUhxRi9NczIycDJiZVp1cXZJUUtlTWwrc3ZWcUh0aXV6V25GNFU2VkltcGtyNGJIbDdlZ1Y5SDZsNlQyU01rajZxRFU1ZTlOZzBabExUdG9zc2hCTG1vcEY3ZTdIeXJURUFtZk9QS1FlMEVnOUUydXJ6eHFCdUc1NGs1MEcySjBGaVBzUUpBaEZpTkd3U2c0UzNIeVZERzd1ZUtkMEw5M3dLT05PWUd2TUtpekNIQitwS3ZFTUpvWjh5OXVpQitIRlhjcDlSYUpxSjk3SHBaVEV2K2xpQ3AyUFNYemNLMHIyNVNjeWpGNmRMb3VLMlNCMzB4QXZKOHRFNTg0K2pxUTZDR2VjVTlYanZsQWp1SmRDckRlVlBzamtuN09QWEcrOFhaVTd6cUhaTm1YWDFZWTRINXJnRUo0OGxyVXJQM0k4UiJdfQ

payload:


signature:
JAET6A3W8KXfOYOE-gM4yfSmN0uMInsj3CrMUtQRcOKZ4V4I9-aZxavMXUnuoIznKj9rBir-O8tFCfjbLjrkXv4SVVuuLiFOW4YigjRYH_Dg4LuwiT72kYGoRYVH14rqSVYCOEBVnWAVT25xAJ05Lu5z2Z5JQ5ReuLIjXd8rSYZbpLaF8jBxKWFBo_L2_6RtqTdNo3OkRYgtP5NgiwtOIyoWBw-XBaXAtFtNdWCU14vOk_tJJ0Sg6lYojE881qWUsi1BgFWfswa1xJXIa8XcpA_-kdTvlYiO2ZJOqXuyJt2_xjA9AV4mx3Tmmxl7q6xcgyOlQBKLBUWJUGET_1ddHdVV6uIC_93OyO9FL_Szw3iWElGLtXerLbEHGlDmR8OJU--NaJCeyDVnbYAeLEkeSu6Kpc0K_nrZzvr8Rn-_nI3C1UjXSN24th_sOkYbQ63NsFgifJlyY8uLS-uu6jWd3Wadydq7J6haX9BB9wtB0bRWzqYutvCYlvygxzFAD9ui
</pre>


**6. reattach the payload - the base64 encoded Bundle - into the JWS payload element.**

note the signature is displayed with the parts labeled and separated with line breaks for easier viewing


```python
split_sig = recd_jws.split('.')
split_sig[1] = recd_b64_canonical_bundle
recd_jws = '.'.join(split_sig)
for i,j in enumerate(recd_jws.split('.')):
    print(f'{labels[i]}:')
    print(f'{j}')
    print()
```

<pre style="border:0; overflow-wrap:break-word;">
header:
eyJhbGciOiJSUzI1NiIsImt0eSI6IlJTIiwidHlwIjoiSldUIiwieDVjIjpbIk1JSUUzekNDQTBlZ0F3SUJBZ0lKQU9LRll2TXdSK3lRTUEwR0NTcUdTSWIzRFFFQkN3VUFNSUdOTVFzd0NRWURWUVFHRXdKVlV6RVRNQkVHQTFVRUNBd0tRMkZzYVdadmNtNXBZVEVTTUJBR0ExVUVCd3dKVTJGMWMyRnNhWFJ2TVJVd0V3WURWUVFLREF4SVpXRnNkR2hsUkdGMFlURXhGekFWQmdOVkJBTU1Ea1Z5YVdNZ1NHRmhjeXdnUkZaTk1TVXdJd1lKS29aSWh2Y05BUWtCRmhabGFHRmhjMEJvWldGc2RHaGxaR0YwWVRFdWIzSm5NQjRYRFRJeE1UQXlOekUzTkRJd05Gb1hEVEl5TVRBeU1qRTNOREl3TkZvd2dZMHhDekFKQmdOVkJBWVRBbFZUTVJNd0VRWURWUVFJREFwRFlXeHBabTl5Ym1saE1SSXdFQVlEVlFRSERBbFRZWFZ6WVd4cGRHOHhGVEFUQmdOVkJBb01ERWhsWVd4MGFHVkVZWFJoTVRFWE1CVUdBMVVFQXd3T1JYSnBZeUJJWVdGekxDQkVWazB4SlRBakJna3Foa2lHOXcwQkNRRVdGbVZvWVdGelFHaGxZV3gwYUdWa1lYUmhNUzV2Y21jd2dnR2lNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUJqd0F3Z2dHS0FvSUJnUURwS2NTa29BTTZzVzIxK3ZXVGVJVk9HeDEwTVdhc1F5N1ZIaWQ2enlxWEFCTSt6bmZCblhlbnlVMGoxRlR2UG1SZk9Eb09EWFZ1UFV3RG9taENIaCtiY2xXOUtNMm81NjNjeFJLRXZCbmFIcnNqdzV5Tm14TzVZakVSYmh0SGRRZXFrdGR3M1ZZRVJSOUhveExPM0Zrc3pSMjkySFRCNHhXM3lXbFYzZ1RrTVFvelBTY0pLSDNiRzhQcXE2QVlQSjdDNFlCSWxVU2RCTVZsM3FuZUVmZzdmdXhpRmZYb2ZkVFZtN3JNaWlHN1g5ejQzUGZpbHFhZWlzZm10UnhBbFJ3RU5YckgzT3ZPRFB5TDByVG5HOENzYkFYWVZJTW1kZEhlNFpGOXBsaDk1c2o0cE1UaEx0Y0pYL285WEhMamg3RW1aeWdKSFdFUXE0UHdGd1pkbWJjZmhDbU9yODhIOEJiVXJ1LzdWNnpic0cxTjFDV2xuZGxiVnpuTCszSU1PcjhrWGFIY2FucWZja2dGVjRFcm5makZKcTFPSWFBbXNNajg1eE1ranlYTHljTEwvdTVuMm82Qmc5My9VUmZxdU9vU0lHT0NSMjVEYVp6cHcyazNzN29FOWRNd0VXWHRmWGdZdGgyYmxqeTV0RkgwR2pwT2t4MDdqN1pUNUhueG5sc0NBd0VBQWFOQU1ENHdEQVlEVlIwVEJBVXdBd0VCL3pBTEJnTlZIUThFQkFNQ0JlQXdJUVlEVlIwUkJCb3dHSUlXZDNkM0xtaGxZV3gwYUdWa1lYUmhhVzVqTG1OdmJUQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FZRUFDdU1VTnE5YXkrK2U1WUM3UUZPOTRyZnp4R1FuRjNHa2xaTkFYbUlyN1BWR2RpR1kyR1R4LzlSdEhDd1RLemtMK3l2S29qZVo5ZFZLOHdyR1ZpUmtPL2pVeVorS2NXUm9rVWpzNTluY0pHUk1TU1J4dGVDUXVqdDRoZjIrL3FWK2Yyc01RdEVyd1BFMzB2YnFSWVVOTk5CVkVRcGFReC9hY0pEVXY5djdzakhpSkRxWHdRK3J6ajk1aUhBSWFlRUhxRi9NczIycDJiZVp1cXZJUUtlTWwrc3ZWcUh0aXV6V25GNFU2VkltcGtyNGJIbDdlZ1Y5SDZsNlQyU01rajZxRFU1ZTlOZzBabExUdG9zc2hCTG1vcEY3ZTdIeXJURUFtZk9QS1FlMEVnOUUydXJ6eHFCdUc1NGs1MEcySjBGaVBzUUpBaEZpTkd3U2c0UzNIeVZERzd1ZUtkMEw5M3dLT05PWUd2TUtpekNIQitwS3ZFTUpvWjh5OXVpQitIRlhjcDlSYUpxSjk3SHBaVEV2K2xpQ3AyUFNYemNLMHIyNVNjeWpGNmRMb3VLMlNCMzB4QXZKOHRFNTg0K2pxUTZDR2VjVTlYanZsQWp1SmRDckRlVlBzamtuN09QWEcrOFhaVTd6cUhaTm1YWDFZWTRINXJnRUo0OGxyVXJQM0k4UiJdfQ

payload:
eyJlbnRyeSI6W3siZnVsbFVybCI6InVybjp1dWlkOjE3YTgwYThkLTRjZjEtNGRlYi1hMWZkLTJkYjExMzBlNWY3NiIsInJlc291cmNlIjp7ImF0dGVzdGVyIjpbeyJtb2RlIjoibGVnYWwiLCJwYXJ0eSI6eyJkaXNwbGF5IjoiRXhhbXBsZSBQcmFjdGl0aW9uZXIiLCJyZWZlcmVuY2UiOiJ1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMifSwidGltZSI6IjIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDAifV0sImF1dGhvciI6W3siZGlzcGxheSI6IkV4YW1wbGUgUHJhY3RpdGlvbmVyIiwicmVmZXJlbmNlIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIn1dLCJkYXRlIjoiMjAyMS0xMC0yNVQyMDoxNjoyOS0wNzowMCIsImVuY291bnRlciI6eyJkaXNwbGF5IjoiRXhhbXBsZSBFbmNvdW50ZXIiLCJyZWZlcmVuY2UiOiJ1cm46dXVpZDo1Y2U1YzgzYS0wMDBmLTQ3ZDItOTQxYy0wMzkzNThjYzkxMTIifSwiaWQiOiIxN2E4MGE4ZC00Y2YxLTRkZWItYTFmZC0yZGIxMTMwZTVmNzYiLCJyZXNvdXJjZVR5cGUiOiJDb21wb3NpdGlvbiIsInNlY3Rpb24iOlt7ImVudHJ5IjpbeyJyZWZlcmVuY2UiOiJ1cm46dXVpZDowMTRhNjhlYy1kNjkxLTQ5ZTAtYjk4MC05MWIwZDkyNGU1NzAifV0sInRpdGxlIjoiQWN0aXZlIENvbmRpdGlvbiAxIn1dLCJzdGF0dXMiOiJmaW5hbCIsInN1YmplY3QiOnsiZGlzcGxheSI6IkV4YW1wbGUgUGF0aWVudCIsInJlZmVyZW5jZSI6InVybjp1dWlkOjk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZSJ9LCJ0ZXh0Ijp7ImRpdiI6IjxkaXYgeG1sbnM9XCJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hodG1sXCI-PHA-PGI-R2VuZXJhdGVkIE5hcnJhdGl2ZTwvYj48L3A-PGRpdiBzdHlsZT1cImRpc3BsYXk6IGlubGluZS1ibG9jazsgYmFja2dyb3VuZC1jb2xvcjogI2Q5ZTBlNzsgcGFkZGluZzogNnB4OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQgIzhkYTFiNDsgYm9yZGVyLXJhZGl1czogNXB4OyBsaW5lLWhlaWdodDogNjAlXCI-PHAgc3R5bGU9XCJtYXJnaW4tYm90dG9tOiAwcHhcIj5SZXNvdXJjZSBcIjE3YTgwYThkLTRjZjEtNGRlYi1hMWZkLTJkYjExMzBlNWY3NlwiIDwvcD48L2Rpdj48cD48Yj5zdGF0dXM8L2I-OiBmaW5hbDwvcD48cD48Yj50eXBlPC9iPjogTWVkaWNhbCByZWNvcmRzIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vbG9pbmMub3JnL1wiPkxPSU5DPC9hPiMxMTUwMy0wKTwvc3Bhbj48L3A-PHA-PGI-ZW5jb3VudGVyPC9iPjogPGEgaHJlZj1cIiNFbmNvdW50ZXJfNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyXCI-U2VlIGFib3ZlICh1cm46dXVpZDo1Y2U1YzgzYS0wMDBmLTQ3ZDItOTQxYy0wMzkzNThjYzkxMTI6IEV4YW1wbGUgRW5jb3VudGVyKTwvYT48L3A-PHA-PGI-ZGF0ZTwvYj46IDIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDA8L3A-PHA-PGI-YXV0aG9yPC9iPjogPGEgaHJlZj1cIiNQcmFjdGl0aW9uZXJfMDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjXCI-U2VlIGFib3ZlICh1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmM6IEV4YW1wbGUgUHJhY3RpdGlvbmVyKTwvYT48L3A-PHA-PGI-dGl0bGU8L2I-OiBBY3RpdmUgQ29uZGl0aW9uczwvcD48aDM-QXR0ZXN0ZXJzPC9oMz48dGFibGUgY2xhc3M9XCJncmlkXCI-PHRyPjx0ZD4tPC90ZD48dGQ-PGI-TW9kZTwvYj48L3RkPjx0ZD48Yj5UaW1lPC9iPjwvdGQ-PHRkPjxiPlBhcnR5PC9iPjwvdGQ-PC90cj48dHI-PHRkPio8L3RkPjx0ZD5sZWdhbDwvdGQ-PHRkPjIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDA8L3RkPjx0ZD48YSBocmVmPVwiI1ByYWN0aXRpb25lcl8wODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmNcIj5TZWUgYWJvdmUgKHVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYzogRXhhbXBsZSBQcmFjdGl0aW9uZXIpPC9hPjwvdGQ-PC90cj48L3RhYmxlPjwvZGl2PiIsInN0YXR1cyI6ImdlbmVyYXRlZCJ9LCJ0aXRsZSI6IkFjdGl2ZSBDb25kaXRpb25zIiwidHlwZSI6eyJjb2RpbmciOlt7ImNvZGUiOiIxMTUwMy0wIiwic3lzdGVtIjoiaHR0cDovL2xvaW5jLm9yZyJ9XSwidGV4dCI6Ik1lZGljYWwgcmVjb3JkcyJ9fX0seyJmdWxsVXJsIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIiwicmVzb3VyY2UiOnsiaWQiOiIwODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMiLCJtZXRhIjp7Imxhc3RVcGRhdGVkIjoiMjAxMy0wNS0wNVQxNjoxMzowM1oifSwibmFtZSI6W3siZmFtaWx5IjoiSGFuY29jayIsImdpdmVuIjpbIkpvaG4iXX1dLCJyZXNvdXJjZVR5cGUiOiJQcmFjdGl0aW9uZXIiLCJ0ZXh0Ijp7ImRpdiI6IjxkaXYgeG1sbnM9XCJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hodG1sXCI-PHA-PGI-R2VuZXJhdGVkIE5hcnJhdGl2ZTwvYj48L3A-PGRpdiBzdHlsZT1cImRpc3BsYXk6IGlubGluZS1ibG9jazsgYmFja2dyb3VuZC1jb2xvcjogI2Q5ZTBlNzsgcGFkZGluZzogNnB4OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQgIzhkYTFiNDsgYm9yZGVyLXJhZGl1czogNXB4OyBsaW5lLWhlaWdodDogNjAlXCI-PHAgc3R5bGU9XCJtYXJnaW4tYm90dG9tOiAwcHhcIj5SZXNvdXJjZSBcIjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliY1wiIFVwZGF0ZWQgXCIyMDEzLTA1LTA1VDE2OjEzOjAzWlwiIDwvcD48L2Rpdj48cD48Yj5uYW1lPC9iPjogSm9obiBIYW5jb2NrIDwvcD48L2Rpdj4iLCJzdGF0dXMiOiJnZW5lcmF0ZWQifX19LHsiZnVsbFVybCI6InVybjp1dWlkOjk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZSIsInJlc291cmNlIjp7ImFjdGl2ZSI6dHJ1ZSwiaWQiOiI5NzBhZjZjOS01YmJkLTQwNjctYjZjMS1kOWIyYzgyM2FlY2UiLCJuYW1lIjpbeyJmYW1pbHkiOiJQYXRpZW50IiwiZ2l2ZW4iOlsiQ0RFWCBFeGFtcGxlIl0sInRleHQiOiJDREVYIEV4YW1wbGUgUGF0aWVudCJ9XSwicmVzb3VyY2VUeXBlIjoiUGF0aWVudCIsInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiOTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlXCIgPC9wPjwvZGl2PjxwPjxiPmFjdGl2ZTwvYj46IHRydWU8L3A-PHA-PGI-bmFtZTwvYj46IENERVggRXhhbXBsZSBQYXRpZW50PC9wPjwvZGl2PiIsInN0YXR1cyI6ImdlbmVyYXRlZCJ9fX0seyJmdWxsVXJsIjoidXJuOnV1aWQ6MDE0YTY4ZWMtZDY5MS00OWUwLWI5ODAtOTFiMGQ5MjRlNTcwIiwicmVzb3VyY2UiOnsiYXNzZXJ0ZXIiOnsicmVmZXJlbmNlIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIn0sImNhdGVnb3J5IjpbeyJjb2RpbmciOlt7ImNvZGUiOiI1NTYwNzAwNiIsImRpc3BsYXkiOiJQcm9ibGVtIiwic3lzdGVtIjoiaHR0cDovL3Nub21lZC5pbmZvL3NjdCJ9LHsiY29kZSI6Ijc1MzI2LTkiLCJkaXNwbGF5IjoiUHJvYmxlbSIsInN5c3RlbSI6Imh0dHA6Ly9sb2luYy5vcmcifV19XSwiY2xpbmljYWxTdGF0dXMiOnsiY29kaW5nIjpbeyJjb2RlIjoiYWN0aXZlIiwic3lzdGVtIjoiaHR0cDovL3Rlcm1pbm9sb2d5LmhsNy5vcmcvQ29kZVN5c3RlbS9jb25kaXRpb24tY2xpbmljYWwifV19LCJjb2RlIjp7ImNvZGluZyI6W3siY29kZSI6IjQ0MDU0MDA2IiwiZGlzcGxheSI6IlR5cGUgMiBEaWFiZXRlcyBNZWxsaXR1cyIsInN5c3RlbSI6Imh0dHA6Ly9zbm9tZWQuaW5mby9zY3QifV19LCJpZCI6IjAxNGE2OGVjLWQ2OTEtNDllMC1iOTgwLTkxYjBkOTI0ZTU3MCIsImlkZW50aWZpZXIiOlt7InN5c3RlbSI6InVybjpvaWQ6MS4zLjYuMS40LjEuMjI4MTIuNC4xMTEuMC40LjEuMi4xIiwidmFsdWUiOiIxIn1dLCJvbnNldERhdGVUaW1lIjoiMjAwNiIsInJlc291cmNlVHlwZSI6IkNvbmRpdGlvbiIsInN1YmplY3QiOnsicmVmZXJlbmNlIjoidXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlIn0sInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiMDE0YTY4ZWMtZDY5MS00OWUwLWI5ODAtOTFiMGQ5MjRlNTcwXCIgPC9wPjwvZGl2PjxwPjxiPmlkZW50aWZpZXI8L2I-OiBpZDogMTwvcD48cD48Yj5jbGluaWNhbFN0YXR1czwvYj46IEFjdGl2ZSA8c3BhbiBzdHlsZT1cImJhY2tncm91bmQ6IExpZ2h0R29sZGVuUm9kWWVsbG93OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQga2hha2lcIj4gKDxhIGhyZWY9XCJodHRwOi8vdGVybWlub2xvZ3kuaGw3Lm9yZy8zLjAuMC9Db2RlU3lzdGVtLWNvbmRpdGlvbi1jbGluaWNhbC5odG1sXCI-Q29uZGl0aW9uIENsaW5pY2FsIFN0YXR1cyBDb2RlczwvYT4jYWN0aXZlKTwvc3Bhbj48L3A-PHA-PGI-Y2F0ZWdvcnk8L2I-OiBQcm9ibGVtIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vYnJvd3Nlci5paHRzZG90b29scy5vcmcvXCI-U05PTUVEIENUPC9hPiM1NTYwNzAwNjsgPGEgaHJlZj1cImh0dHBzOi8vbG9pbmMub3JnL1wiPkxPSU5DPC9hPiM3NTMyNi05KTwvc3Bhbj48L3A-PHA-PGI-Y29kZTwvYj46IFR5cGUgMiBEaWFiZXRlcyBNZWxsaXR1cyA8c3BhbiBzdHlsZT1cImJhY2tncm91bmQ6IExpZ2h0R29sZGVuUm9kWWVsbG93OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQga2hha2lcIj4gKDxhIGhyZWY9XCJodHRwczovL2Jyb3dzZXIuaWh0c2RvdG9vbHMub3JnL1wiPlNOT01FRCBDVDwvYT4jNDQwNTQwMDYpPC9zcGFuPjwvcD48cD48Yj5zdWJqZWN0PC9iPjogPGEgaHJlZj1cIiNQYXRpZW50Xzk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZVwiPlNlZSBhYm92ZSAodXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlKTwvYT48L3A-PHA-PGI-b25zZXQ8L2I-OiAyMDA2LTAxLTAxPC9wPjxwPjxiPmFzc2VydGVyPC9iPjogPGEgaHJlZj1cIiNQcmFjdGl0aW9uZXJfMDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjXCI-U2VlIGFib3ZlICh1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMpPC9hPjwvcD48L2Rpdj4iLCJzdGF0dXMiOiJnZW5lcmF0ZWQifX19LHsiZnVsbFVybCI6InVybjp1dWlkOjVjZTVjODNhLTAwMGYtNDdkMi05NDFjLTAzOTM1OGNjOTExMiIsInJlc291cmNlIjp7ImNsYXNzIjp7ImNvZGUiOiJFTUVSIiwic3lzdGVtIjoiaHR0cDovL3Rlcm1pbm9sb2d5LmhsNy5vcmcvQ29kZVN5c3RlbS92My1BY3RDb2RlIn0sImlkIjoiNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyIiwicGFydGljaXBhbnQiOlt7ImluZGl2aWR1YWwiOnsiZGlzcGxheSI6IkpvaG4gSGFuY29jayIsInJlZmVyZW5jZSI6InVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYyJ9fV0sInBlcmlvZCI6eyJlbmQiOiIyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwIiwic3RhcnQiOiIyMDIxLTEwLTI1VDIwOjEwOjI5LTA3OjAwIn0sInJlc291cmNlVHlwZSI6IkVuY291bnRlciIsInNlcnZpY2VQcm92aWRlciI6eyJkaXNwbGF5IjoiQ0RFWCBFeGFtcGxlIE9yZ2FuaXphdGlvbiIsInJlZmVyZW5jZSI6InVybjp1dWlkOmUzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhMyJ9LCJzdGF0dXMiOiJmaW5pc2hlZCIsInN1YmplY3QiOnsiZGlzcGxheSI6IkNERVggRXhhbXBsZSBQYXRpZW50IiwicmVmZXJlbmNlIjoidXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlIn0sInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyXCIgPC9wPjwvZGl2PjxwPjxiPnN0YXR1czwvYj46IGZpbmlzaGVkPC9wPjxwPjxiPmNsYXNzPC9iPjogZW1lcmdlbmN5IChEZXRhaWxzOiBodHRwOi8vdGVybWlub2xvZ3kuaGw3Lm9yZy9Db2RlU3lzdGVtL3YzLUFjdENvZGUgY29kZSBFTUVSID0gJ2VtZXJnZW5jeScsIHN0YXRlZCBhcyAnbnVsbCcpPC9wPjxwPjxiPnR5cGU8L2I-OiBVbmtub3duIChxdWFsaWZpZXIgdmFsdWUpIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vYnJvd3Nlci5paHRzZG90b29scy5vcmcvXCI-U05PTUVEIENUPC9hPiMyNjE2NjUwMDYpPC9zcGFuPjwvcD48cD48Yj5zdWJqZWN0PC9iPjogPGEgaHJlZj1cIiNQYXRpZW50Xzk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZVwiPlNlZSBhYm92ZSAodXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlOiBDREVYIEV4YW1wbGUgUGF0aWVudCk8L2E-PC9wPjxoMz5QYXJ0aWNpcGFudHM8L2gzPjx0YWJsZSBjbGFzcz1cImdyaWRcIj48dHI-PHRkPi08L3RkPjx0ZD48Yj5JbmRpdmlkdWFsPC9iPjwvdGQ-PC90cj48dHI-PHRkPio8L3RkPjx0ZD48YSBocmVmPVwiI1ByYWN0aXRpb25lcl8wODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmNcIj5TZWUgYWJvdmUgKHVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYzogSm9obiBIYW5jb2NrKTwvYT48L3RkPjwvdHI-PC90YWJsZT48cD48Yj5wZXJpb2Q8L2I-OiAyMDIxLTEwLTI1VDIwOjEwOjI5LTA3OjAwIC0tJmd0OyAyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwPC9wPjxwPjxiPnNlcnZpY2VQcm92aWRlcjwvYj46IDxhIGhyZWY9XCIjT3JnYW5pemF0aW9uX2UzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhM1wiPlNlZSBhYm92ZSAodXJuOnV1aWQ6ZTM3ZjAwNGItZGMxMC00MjJiLWI4MzMtY2RhYTEwYTA1NWEzOiBDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uKTwvYT48L3A-PC9kaXY-Iiwic3RhdHVzIjoiZ2VuZXJhdGVkIn0sInR5cGUiOlt7ImNvZGluZyI6W3siY29kZSI6IjI2MTY2NTAwNiIsImRpc3BsYXkiOiJVbmtub3duIChxdWFsaWZpZXIgdmFsdWUpIiwic3lzdGVtIjoiaHR0cDovL3Nub21lZC5pbmZvL3NjdCJ9XSwidGV4dCI6IlVua25vd24gKHF1YWxpZmllciB2YWx1ZSkifV19fSx7ImZ1bGxVcmwiOiJ1cm46dXVpZDplMzdmMDA0Yi1kYzEwLTQyMmItYjgzMy1jZGFhMTBhMDU1YTMiLCJyZXNvdXJjZSI6eyJhY3RpdmUiOnRydWUsImFkZHJlc3MiOlt7ImNpdHkiOiJCb3N0b24iLCJjb3VudHJ5IjoiVVNBIiwibGluZSI6WyIxIENERVggTGFuZSJdLCJwb3N0YWxDb2RlIjoiMDEwMDIiLCJzdGF0ZSI6Ik1BIn1dLCJpZCI6ImUzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhMyIsIm5hbWUiOiJDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uIiwicmVzb3VyY2VUeXBlIjoiT3JnYW5pemF0aW9uIiwidGVsZWNvbSI6W3sic3lzdGVtIjoicGhvbmUiLCJ2YWx1ZSI6IigrMSkgNTU1LTU1NS01NTU1In0seyJzeXN0ZW0iOiJlbWFpbCIsInZhbHVlIjoiY3VzdG9tZXItc2VydmljZUBleGFtcGxlLm9yZyJ9XSwidGV4dCI6eyJkaXYiOiI8ZGl2IHhtbG5zPVwiaHR0cDovL3d3dy53My5vcmcvMTk5OS94aHRtbFwiPjxwPjxiPkdlbmVyYXRlZCBOYXJyYXRpdmU8L2I-PC9wPjxkaXYgc3R5bGU9XCJkaXNwbGF5OiBpbmxpbmUtYmxvY2s7IGJhY2tncm91bmQtY29sb3I6ICNkOWUwZTc7IHBhZGRpbmc6IDZweDsgbWFyZ2luOiA0cHg7IGJvcmRlcjogMXB4IHNvbGlkICM4ZGExYjQ7IGJvcmRlci1yYWRpdXM6IDVweDsgbGluZS1oZWlnaHQ6IDYwJVwiPjxwIHN0eWxlPVwibWFyZ2luLWJvdHRvbTogMHB4XCI-UmVzb3VyY2UgXCJlMzdmMDA0Yi1kYzEwLTQyMmItYjgzMy1jZGFhMTBhMDU1YTNcIiA8L3A-PC9kaXY-PHA-PGI-YWN0aXZlPC9iPjogdHJ1ZTwvcD48cD48Yj5uYW1lPC9iPjogQ0RFWCBFeGFtcGxlIE9yZ2FuaXphdGlvbjwvcD48cD48Yj50ZWxlY29tPC9iPjogcGg6ICgrMSkgNTU1LTU1NS01NTU1LCA8YSBocmVmPVwibWFpbHRvOmN1c3RvbWVyLXNlcnZpY2VAZXhhbXBsZS5vcmdcIj5jdXN0b21lci1zZXJ2aWNlQGV4YW1wbGUub3JnPC9hPjwvcD48cD48Yj5hZGRyZXNzPC9iPjogMSBDREVYIExhbmUgQm9zdG9uIE1BIDAxMDAyIFVTQSA8L3A-PC9kaXY-Iiwic3RhdHVzIjoiZ2VuZXJhdGVkIn19fV0sImlkZW50aWZpZXIiOnsic3lzdGVtIjoidXJuOmlldGY6cmZjOjM5ODYiLCJ2YWx1ZSI6InVybjp1dWlkOmMxNzM1MzVlLTEzNWUtNDhlMy1hYjY0LTM4YmFjYzY4ZGJhOCJ9LCJyZXNvdXJjZVR5cGUiOiJCdW5kbGUiLCJ0aW1lc3RhbXAiOiIyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwIiwidHlwZSI6ImRvY3VtZW50In0

signature:
JAET6A3W8KXfOYOE-gM4yfSmN0uMInsj3CrMUtQRcOKZ4V4I9-aZxavMXUnuoIznKj9rBir-O8tFCfjbLjrkXv4SVVuuLiFOW4YigjRYH_Dg4LuwiT72kYGoRYVH14rqSVYCOEBVnWAVT25xAJ05Lu5z2Z5JQ5ReuLIjXd8rSYZbpLaF8jBxKWFBo_L2_6RtqTdNo3OkRYgtP5NgiwtOIyoWBw-XBaXAtFtNdWCU14vOk_tJJ0Sg6lYojE881qWUsi1BgFWfswa1xJXIa8XcpA_-kdTvlYiO2ZJOqXuyJt2_xjA9AV4mx3Tmmxl7q6xcgyOlQBKLBUWJUGET_1ddHdVV6uIC_93OyO9FL_Szw3iWElGLtXerLbEHGlDmR8OJU--NaJCeyDVnbYAeLEkeSu6Kpc0K_nrZzvr8Rn-_nI3C1UjXSN24th_sOkYbQ63NsFgifJlyY8uLS-uu6jWd3Wadydq7J6haX9BB9wtB0bRWzqYutvCYlvygxzFAD9ui
</pre>


**7. Obtain public Key from the first certificate in JWS header `"x5c"` key**

- base64 decode the key value
- Verify Issuer, Validity Dates, Subject,and KeyUsage of certificate,
- Get the “Subject Public Key Info” from the cert to verify the signature


```python
recd_header = jws.get_unverified_header(recd_jws)
recd_header
```




<pre style="border:0; overflow-wrap:break-word;">
{'alg': 'RS256',
 'kty': 'RS',
 'typ': 'JWT',
 'x5c': ['MIIE3zCCA0egAwIBAgIJAOKFYvMwR+yQMA0GCSqGSIb3DQEBCwUAMIGNMQswCQYDVQQGEwJVUzETMBEGA1UECAwKQ2FsaWZvcm5pYTESMBAGA1UEBwwJU2F1c2FsaXRvMRUwEwYDVQQKDAxIZWFsdGhlRGF0YTExFzAVBgNVBAMMDkVyaWMgSGFhcywgRFZNMSUwIwYJKoZIhvcNAQkBFhZlaGFhc0BoZWFsdGhlZGF0YTEub3JnMB4XDTIxMTAyNzE3NDIwNFoXDTIyMTAyMjE3NDIwNFowgY0xCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApDYWxpZm9ybmlhMRIwEAYDVQQHDAlTYXVzYWxpdG8xFTATBgNVBAoMDEhlYWx0aGVEYXRhMTEXMBUGA1UEAwwORXJpYyBIYWFzLCBEVk0xJTAjBgkqhkiG9w0BCQEWFmVoYWFzQGhlYWx0aGVkYXRhMS5vcmcwggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAwggGKAoIBgQDpKcSkoAM6sW21+vWTeIVOGx10MWasQy7VHid6zyqXABM+znfBnXenyU0j1FTvPmRfODoODXVuPUwDomhCHh+bclW9KM2o563cxRKEvBnaHrsjw5yNmxO5YjERbhtHdQeqktdw3VYERR9HoxLO3FkszR292HTB4xW3yWlV3gTkMQozPScJKH3bG8Pqq6AYPJ7C4YBIlUSdBMVl3qneEfg7fuxiFfXofdTVm7rMiiG7X9z43PfilqaeisfmtRxAlRwENXrH3OvODPyL0rTnG8CsbAXYVIMmddHe4ZF9plh95sj4pMThLtcJX/o9XHLjh7EmZygJHWEQq4PwFwZdmbcfhCmOr88H8BbUru/7V6zbsG1N1CWlndlbVznL+3IMOr8kXaHcanqfckgFV4ErnfjFJq1OIaAmsMj85xMkjyXLycLL/u5n2o6Bg93/URfquOoSIGOCR25DaZzpw2k3s7oE9dMwEWXtfXgYth2bljy5tFH0GjpOkx07j7ZT5HnxnlsCAwEAAaNAMD4wDAYDVR0TBAUwAwEB/zALBgNVHQ8EBAMCBeAwIQYDVR0RBBowGIIWd3d3LmhlYWx0aGVkYXRhaW5jLmNvbTANBgkqhkiG9w0BAQsFAAOCAYEACuMUNq9ay++e5YC7QFO94rfzxGQnF3GklZNAXmIr7PVGdiGY2GTx/9RtHCwTKzkL+yvKojeZ9dVK8wrGViRkO/jUyZ+KcWRokUjs59ncJGRMSSRxteCQujt4hf2+/qV+f2sMQtErwPE30vbqRYUNNNBVEQpaQx/acJDUv9v7sjHiJDqXwQ+rzj95iHAIaeEHqF/Ms22p2beZuqvIQKeMl+svVqHtiuzWnF4U6VImpkr4bHl7egV9H6l6T2SMkj6qDU5e9Ng0ZlLTtosshBLmopF7e7HyrTEAmfOPKQe0Eg9E2urzxqBuG54k50G2J0FiPsQJAhFiNGwSg4S3HyVDG7ueKd0L93wKONOYGvMKizCHB+pKvEMJoZ8y9uiB+HFXcp9RaJqJ97HpZTEv+liCp2PSXzcK0r25ScyjF6dLouK2SB30xAvJ8tE584+jqQ6CGecU9XjvlAjuJdCrDeVPsjkn7OPXG+8XZU7zqHZNmXX1YY4H5rgEJ48lrUrP3I8R']}
</pre>



```python
recd_cert = b64decode(recd_header['x5c'][0])
with open('recd_cert.der', 'wb') as f:
    f.write(recd_cert)
!openssl x509 -in recd_cert.der -inform DER -text
```

<pre style="border:0; overflow-wrap:break-word;">
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 16322561221100825744 (0xe28562f33047ec90)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=US, ST=California, L=Sausalito, O=HealtheData1, CN=Eric Haas, DVM/emailAddress=ehaas@healthedata1.org
        Validity
            Not Before: Oct 27 17:42:04 2021 GMT
            Not After : Oct 22 17:42:04 2022 GMT
        Subject: C=US, ST=California, L=Sausalito, O=HealtheData1, CN=Eric Haas, DVM/emailAddress=ehaas@healthedata1.org
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (3072 bit)
                Modulus:
                    00:e9:29:c4:a4:a0:03:3a:b1:6d:b5:fa:f5:93:78:
                    85:4e:1b:1d:74:31:66:ac:43:2e:d5:1e:27:7a:cf:
                    2a:97:00:13:3e:ce:77:c1:9d:77:a7:c9:4d:23:d4:
                    54:ef:3e:64:5f:38:3a:0e:0d:75:6e:3d:4c:03:a2:
                    68:42:1e:1f:9b:72:55:bd:28:cd:a8:e7:ad:dc:c5:
                    12:84:bc:19:da:1e:bb:23:c3:9c:8d:9b:13:b9:62:
                    31:11:6e:1b:47:75:07:aa:92:d7:70:dd:56:04:45:
                    1f:47:a3:12:ce:dc:59:2c:cd:1d:bd:d8:74:c1:e3:
                    15:b7:c9:69:55:de:04:e4:31:0a:33:3d:27:09:28:
                    7d:db:1b:c3:ea:ab:a0:18:3c:9e:c2:e1:80:48:95:
                    44:9d:04:c5:65:de:a9:de:11:f8:3b:7e:ec:62:15:
                    f5:e8:7d:d4:d5:9b:ba:cc:8a:21:bb:5f:dc:f8:dc:
                    f7:e2:96:a6:9e:8a:c7:e6:b5:1c:40:95:1c:04:35:
                    7a:c7:dc:eb:ce:0c:fc:8b:d2:b4:e7:1b:c0:ac:6c:
                    05:d8:54:83:26:75:d1:de:e1:91:7d:a6:58:7d:e6:
                    c8:f8:a4:c4:e1:2e:d7:09:5f:fa:3d:5c:72:e3:87:
                    b1:26:67:28:09:1d:61:10:ab:83:f0:17:06:5d:99:
                    b7:1f:84:29:8e:af:cf:07:f0:16:d4:ae:ef:fb:57:
                    ac:db:b0:6d:4d:d4:25:a5:9d:d9:5b:57:39:cb:fb:
                    72:0c:3a:bf:24:5d:a1:dc:6a:7a:9f:72:48:05:57:
                    81:2b:9d:f8:c5:26:ad:4e:21:a0:26:b0:c8:fc:e7:
                    13:24:8f:25:cb:c9:c2:cb:fe:ee:67:da:8e:81:83:
                    dd:ff:51:17:ea:b8:ea:12:20:63:82:47:6e:43:69:
                    9c:e9:c3:69:37:b3:ba:04:f5:d3:30:11:65:ed:7d:
                    78:18:b6:1d:9b:96:3c:b9:b4:51:f4:1a:3a:4e:93:
                    1d:3b:8f:b6:53:e4:79:f1:9e:5b
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints:
                CA:TRUE
            X509v3 Key Usage:
                Digital Signature, Non Repudiation, Key Encipherment
            X509v3 Subject Alternative Name:
                DNS:www.healthedatainc.com
    Signature Algorithm: sha256WithRSAEncryption
         0a:e3:14:36:af:5a:cb:ef:9e:e5:80:bb:40:53:bd:e2:b7:f3:
         c4:64:27:17:71:a4:95:93:40:5e:62:2b:ec:f5:46:76:21:98:
         d8:64:f1:ff:d4:6d:1c:2c:13:2b:39:0b:fb:2b:ca:a2:37:99:
         f5:d5:4a:f3:0a:c6:56:24:64:3b:f8:d4:c9:9f:8a:71:64:68:
         91:48:ec:e7:d9:dc:24:64:4c:49:24:71:b5:e0:90:ba:3b:78:
         85:fd:be:fe:a5:7e:7f:6b:0c:42:d1:2b:c0:f1:37:d2:f6:ea:
         45:85:0d:34:d0:55:11:0a:5a:43:1f:da:70:90:d4:bf:db:fb:
         b2:31:e2:24:3a:97:c1:0f:ab:ce:3f:79:88:70:08:69:e1:07:
         a8:5f:cc:b3:6d:a9:d9:b7:99:ba:ab:c8:40:a7:8c:97:eb:2f:
         56:a1:ed:8a:ec:d6:9c:5e:14:e9:52:26:a6:4a:f8:6c:79:7b:
         7a:05:7d:1f:a9:7a:4f:64:8c:92:3e:aa:0d:4e:5e:f4:d8:34:
         66:52:d3:b6:8b:2c:84:12:e6:a2:91:7b:7b:b1:f2:ad:31:00:
         99:f3:8f:29:07:b4:12:0f:44:da:ea:f3:c6:a0:6e:1b:9e:24:
         e7:41:b6:27:41:62:3e:c4:09:02:11:62:34:6c:12:83:84:b7:
         1f:25:43:1b:bb:9e:29:dd:0b:f7:7c:0a:38:d3:98:1a:f3:0a:
         8b:30:87:07:ea:4a:bc:43:09:a1:9f:32:f6:e8:81:f8:71:57:
         72:9f:51:68:9a:89:f7:b1:e9:65:31:2f:fa:58:82:a7:63:d2:
         5f:37:0a:d2:bd:b9:49:cc:a3:17:a7:4b:a2:e2:b6:48:1d:f4:
         c4:0b:c9:f2:d1:39:f3:8f:a3:a9:0e:82:19:e7:14:f5:78:ef:
         94:08:ee:25:d0:ab:0d:e5:4f:b2:39:27:ec:e3:d7:1b:ef:17:
         65:4e:f3:a8:76:4d:99:75:f5:61:8e:07:e6:b8:04:27:8f:25:
         ad:4a:cf:dc:8f:11
-----BEGIN CERTIFICATE-----
MIIE3zCCA0egAwIBAgIJAOKFYvMwR+yQMA0GCSqGSIb3DQEBCwUAMIGNMQswCQYD
VQQGEwJVUzETMBEGA1UECAwKQ2FsaWZvcm5pYTESMBAGA1UEBwwJU2F1c2FsaXRv
MRUwEwYDVQQKDAxIZWFsdGhlRGF0YTExFzAVBgNVBAMMDkVyaWMgSGFhcywgRFZN
MSUwIwYJKoZIhvcNAQkBFhZlaGFhc0BoZWFsdGhlZGF0YTEub3JnMB4XDTIxMTAy
NzE3NDIwNFoXDTIyMTAyMjE3NDIwNFowgY0xCzAJBgNVBAYTAlVTMRMwEQYDVQQI
DApDYWxpZm9ybmlhMRIwEAYDVQQHDAlTYXVzYWxpdG8xFTATBgNVBAoMDEhlYWx0
aGVEYXRhMTEXMBUGA1UEAwwORXJpYyBIYWFzLCBEVk0xJTAjBgkqhkiG9w0BCQEW
FmVoYWFzQGhlYWx0aGVkYXRhMS5vcmcwggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAw
ggGKAoIBgQDpKcSkoAM6sW21+vWTeIVOGx10MWasQy7VHid6zyqXABM+znfBnXen
yU0j1FTvPmRfODoODXVuPUwDomhCHh+bclW9KM2o563cxRKEvBnaHrsjw5yNmxO5
YjERbhtHdQeqktdw3VYERR9HoxLO3FkszR292HTB4xW3yWlV3gTkMQozPScJKH3b
G8Pqq6AYPJ7C4YBIlUSdBMVl3qneEfg7fuxiFfXofdTVm7rMiiG7X9z43Pfilqae
isfmtRxAlRwENXrH3OvODPyL0rTnG8CsbAXYVIMmddHe4ZF9plh95sj4pMThLtcJ
X/o9XHLjh7EmZygJHWEQq4PwFwZdmbcfhCmOr88H8BbUru/7V6zbsG1N1CWlndlb
VznL+3IMOr8kXaHcanqfckgFV4ErnfjFJq1OIaAmsMj85xMkjyXLycLL/u5n2o6B
g93/URfquOoSIGOCR25DaZzpw2k3s7oE9dMwEWXtfXgYth2bljy5tFH0GjpOkx07
j7ZT5HnxnlsCAwEAAaNAMD4wDAYDVR0TBAUwAwEB/zALBgNVHQ8EBAMCBeAwIQYD
VR0RBBowGIIWd3d3LmhlYWx0aGVkYXRhaW5jLmNvbTANBgkqhkiG9w0BAQsFAAOC
AYEACuMUNq9ay++e5YC7QFO94rfzxGQnF3GklZNAXmIr7PVGdiGY2GTx/9RtHCwT
KzkL+yvKojeZ9dVK8wrGViRkO/jUyZ+KcWRokUjs59ncJGRMSSRxteCQujt4hf2+
/qV+f2sMQtErwPE30vbqRYUNNNBVEQpaQx/acJDUv9v7sjHiJDqXwQ+rzj95iHAI
aeEHqF/Ms22p2beZuqvIQKeMl+svVqHtiuzWnF4U6VImpkr4bHl7egV9H6l6T2SM
kj6qDU5e9Ng0ZlLTtosshBLmopF7e7HyrTEAmfOPKQe0Eg9E2urzxqBuG54k50G2
J0FiPsQJAhFiNGwSg4S3HyVDG7ueKd0L93wKONOYGvMKizCHB+pKvEMJoZ8y9uiB
+HFXcp9RaJqJ97HpZTEv+liCp2PSXzcK0r25ScyjF6dLouK2SB30xAvJ8tE584+j
qQ6CGecU9XjvlAjuJdCrDeVPsjkn7OPXG+8XZU7zqHZNmXX1YY4H5rgEJ48lrUrP
3I8R
-----END CERTIFICATE-----
</pre>

**10. Verify Signature using the public key or the X.509 Certificate**

Alternatively:
1. visit https://jwt.io.
1. At the top of the page, select "RS256" for the algorithm.
1. Paste the JWS value printed below into the “Encoded” field.
1. The plaintext JWT will be displayed in the “Decoded:Payload” field.
1. The X509 Cert above will appear in the "Verify Signature" box.
1. If verified, a “Signature Verified” message will appear  in the bottom left hand corner.


```python
recd_jws
```




<pre style="border:0; overflow-wrap:break-word;">
'eyJhbGciOiJSUzI1NiIsImt0eSI6IlJTIiwidHlwIjoiSldUIiwieDVjIjpbIk1JSUUzekNDQTBlZ0F3SUJBZ0lKQU9LRll2TXdSK3lRTUEwR0NTcUdTSWIzRFFFQkN3VUFNSUdOTVFzd0NRWURWUVFHRXdKVlV6RVRNQkVHQTFVRUNBd0tRMkZzYVdadmNtNXBZVEVTTUJBR0ExVUVCd3dKVTJGMWMyRnNhWFJ2TVJVd0V3WURWUVFLREF4SVpXRnNkR2hsUkdGMFlURXhGekFWQmdOVkJBTU1Ea1Z5YVdNZ1NHRmhjeXdnUkZaTk1TVXdJd1lKS29aSWh2Y05BUWtCRmhabGFHRmhjMEJvWldGc2RHaGxaR0YwWVRFdWIzSm5NQjRYRFRJeE1UQXlOekUzTkRJd05Gb1hEVEl5TVRBeU1qRTNOREl3TkZvd2dZMHhDekFKQmdOVkJBWVRBbFZUTVJNd0VRWURWUVFJREFwRFlXeHBabTl5Ym1saE1SSXdFQVlEVlFRSERBbFRZWFZ6WVd4cGRHOHhGVEFUQmdOVkJBb01ERWhsWVd4MGFHVkVZWFJoTVRFWE1CVUdBMVVFQXd3T1JYSnBZeUJJWVdGekxDQkVWazB4SlRBakJna3Foa2lHOXcwQkNRRVdGbVZvWVdGelFHaGxZV3gwYUdWa1lYUmhNUzV2Y21jd2dnR2lNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUJqd0F3Z2dHS0FvSUJnUURwS2NTa29BTTZzVzIxK3ZXVGVJVk9HeDEwTVdhc1F5N1ZIaWQ2enlxWEFCTSt6bmZCblhlbnlVMGoxRlR2UG1SZk9Eb09EWFZ1UFV3RG9taENIaCtiY2xXOUtNMm81NjNjeFJLRXZCbmFIcnNqdzV5Tm14TzVZakVSYmh0SGRRZXFrdGR3M1ZZRVJSOUhveExPM0Zrc3pSMjkySFRCNHhXM3lXbFYzZ1RrTVFvelBTY0pLSDNiRzhQcXE2QVlQSjdDNFlCSWxVU2RCTVZsM3FuZUVmZzdmdXhpRmZYb2ZkVFZtN3JNaWlHN1g5ejQzUGZpbHFhZWlzZm10UnhBbFJ3RU5YckgzT3ZPRFB5TDByVG5HOENzYkFYWVZJTW1kZEhlNFpGOXBsaDk1c2o0cE1UaEx0Y0pYL285WEhMamg3RW1aeWdKSFdFUXE0UHdGd1pkbWJjZmhDbU9yODhIOEJiVXJ1LzdWNnpic0cxTjFDV2xuZGxiVnpuTCszSU1PcjhrWGFIY2FucWZja2dGVjRFcm5makZKcTFPSWFBbXNNajg1eE1ranlYTHljTEwvdTVuMm82Qmc5My9VUmZxdU9vU0lHT0NSMjVEYVp6cHcyazNzN29FOWRNd0VXWHRmWGdZdGgyYmxqeTV0RkgwR2pwT2t4MDdqN1pUNUhueG5sc0NBd0VBQWFOQU1ENHdEQVlEVlIwVEJBVXdBd0VCL3pBTEJnTlZIUThFQkFNQ0JlQXdJUVlEVlIwUkJCb3dHSUlXZDNkM0xtaGxZV3gwYUdWa1lYUmhhVzVqTG1OdmJUQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FZRUFDdU1VTnE5YXkrK2U1WUM3UUZPOTRyZnp4R1FuRjNHa2xaTkFYbUlyN1BWR2RpR1kyR1R4LzlSdEhDd1RLemtMK3l2S29qZVo5ZFZLOHdyR1ZpUmtPL2pVeVorS2NXUm9rVWpzNTluY0pHUk1TU1J4dGVDUXVqdDRoZjIrL3FWK2Yyc01RdEVyd1BFMzB2YnFSWVVOTk5CVkVRcGFReC9hY0pEVXY5djdzakhpSkRxWHdRK3J6ajk1aUhBSWFlRUhxRi9NczIycDJiZVp1cXZJUUtlTWwrc3ZWcUh0aXV6V25GNFU2VkltcGtyNGJIbDdlZ1Y5SDZsNlQyU01rajZxRFU1ZTlOZzBabExUdG9zc2hCTG1vcEY3ZTdIeXJURUFtZk9QS1FlMEVnOUUydXJ6eHFCdUc1NGs1MEcySjBGaVBzUUpBaEZpTkd3U2c0UzNIeVZERzd1ZUtkMEw5M3dLT05PWUd2TUtpekNIQitwS3ZFTUpvWjh5OXVpQitIRlhjcDlSYUpxSjk3SHBaVEV2K2xpQ3AyUFNYemNLMHIyNVNjeWpGNmRMb3VLMlNCMzB4QXZKOHRFNTg0K2pxUTZDR2VjVTlYanZsQWp1SmRDckRlVlBzamtuN09QWEcrOFhaVTd6cUhaTm1YWDFZWTRINXJnRUo0OGxyVXJQM0k4UiJdfQ.eyJlbnRyeSI6W3siZnVsbFVybCI6InVybjp1dWlkOjE3YTgwYThkLTRjZjEtNGRlYi1hMWZkLTJkYjExMzBlNWY3NiIsInJlc291cmNlIjp7ImF0dGVzdGVyIjpbeyJtb2RlIjoibGVnYWwiLCJwYXJ0eSI6eyJkaXNwbGF5IjoiRXhhbXBsZSBQcmFjdGl0aW9uZXIiLCJyZWZlcmVuY2UiOiJ1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMifSwidGltZSI6IjIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDAifV0sImF1dGhvciI6W3siZGlzcGxheSI6IkV4YW1wbGUgUHJhY3RpdGlvbmVyIiwicmVmZXJlbmNlIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIn1dLCJkYXRlIjoiMjAyMS0xMC0yNVQyMDoxNjoyOS0wNzowMCIsImVuY291bnRlciI6eyJkaXNwbGF5IjoiRXhhbXBsZSBFbmNvdW50ZXIiLCJyZWZlcmVuY2UiOiJ1cm46dXVpZDo1Y2U1YzgzYS0wMDBmLTQ3ZDItOTQxYy0wMzkzNThjYzkxMTIifSwiaWQiOiIxN2E4MGE4ZC00Y2YxLTRkZWItYTFmZC0yZGIxMTMwZTVmNzYiLCJyZXNvdXJjZVR5cGUiOiJDb21wb3NpdGlvbiIsInNlY3Rpb24iOlt7ImVudHJ5IjpbeyJyZWZlcmVuY2UiOiJ1cm46dXVpZDowMTRhNjhlYy1kNjkxLTQ5ZTAtYjk4MC05MWIwZDkyNGU1NzAifV0sInRpdGxlIjoiQWN0aXZlIENvbmRpdGlvbiAxIn1dLCJzdGF0dXMiOiJmaW5hbCIsInN1YmplY3QiOnsiZGlzcGxheSI6IkV4YW1wbGUgUGF0aWVudCIsInJlZmVyZW5jZSI6InVybjp1dWlkOjk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZSJ9LCJ0ZXh0Ijp7ImRpdiI6IjxkaXYgeG1sbnM9XCJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hodG1sXCI-PHA-PGI-R2VuZXJhdGVkIE5hcnJhdGl2ZTwvYj48L3A-PGRpdiBzdHlsZT1cImRpc3BsYXk6IGlubGluZS1ibG9jazsgYmFja2dyb3VuZC1jb2xvcjogI2Q5ZTBlNzsgcGFkZGluZzogNnB4OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQgIzhkYTFiNDsgYm9yZGVyLXJhZGl1czogNXB4OyBsaW5lLWhlaWdodDogNjAlXCI-PHAgc3R5bGU9XCJtYXJnaW4tYm90dG9tOiAwcHhcIj5SZXNvdXJjZSBcIjE3YTgwYThkLTRjZjEtNGRlYi1hMWZkLTJkYjExMzBlNWY3NlwiIDwvcD48L2Rpdj48cD48Yj5zdGF0dXM8L2I-OiBmaW5hbDwvcD48cD48Yj50eXBlPC9iPjogTWVkaWNhbCByZWNvcmRzIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vbG9pbmMub3JnL1wiPkxPSU5DPC9hPiMxMTUwMy0wKTwvc3Bhbj48L3A-PHA-PGI-ZW5jb3VudGVyPC9iPjogPGEgaHJlZj1cIiNFbmNvdW50ZXJfNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyXCI-U2VlIGFib3ZlICh1cm46dXVpZDo1Y2U1YzgzYS0wMDBmLTQ3ZDItOTQxYy0wMzkzNThjYzkxMTI6IEV4YW1wbGUgRW5jb3VudGVyKTwvYT48L3A-PHA-PGI-ZGF0ZTwvYj46IDIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDA8L3A-PHA-PGI-YXV0aG9yPC9iPjogPGEgaHJlZj1cIiNQcmFjdGl0aW9uZXJfMDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjXCI-U2VlIGFib3ZlICh1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmM6IEV4YW1wbGUgUHJhY3RpdGlvbmVyKTwvYT48L3A-PHA-PGI-dGl0bGU8L2I-OiBBY3RpdmUgQ29uZGl0aW9uczwvcD48aDM-QXR0ZXN0ZXJzPC9oMz48dGFibGUgY2xhc3M9XCJncmlkXCI-PHRyPjx0ZD4tPC90ZD48dGQ-PGI-TW9kZTwvYj48L3RkPjx0ZD48Yj5UaW1lPC9iPjwvdGQ-PHRkPjxiPlBhcnR5PC9iPjwvdGQ-PC90cj48dHI-PHRkPio8L3RkPjx0ZD5sZWdhbDwvdGQ-PHRkPjIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDA8L3RkPjx0ZD48YSBocmVmPVwiI1ByYWN0aXRpb25lcl8wODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmNcIj5TZWUgYWJvdmUgKHVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYzogRXhhbXBsZSBQcmFjdGl0aW9uZXIpPC9hPjwvdGQ-PC90cj48L3RhYmxlPjwvZGl2PiIsInN0YXR1cyI6ImdlbmVyYXRlZCJ9LCJ0aXRsZSI6IkFjdGl2ZSBDb25kaXRpb25zIiwidHlwZSI6eyJjb2RpbmciOlt7ImNvZGUiOiIxMTUwMy0wIiwic3lzdGVtIjoiaHR0cDovL2xvaW5jLm9yZyJ9XSwidGV4dCI6Ik1lZGljYWwgcmVjb3JkcyJ9fX0seyJmdWxsVXJsIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIiwicmVzb3VyY2UiOnsiaWQiOiIwODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMiLCJtZXRhIjp7Imxhc3RVcGRhdGVkIjoiMjAxMy0wNS0wNVQxNjoxMzowM1oifSwibmFtZSI6W3siZmFtaWx5IjoiSGFuY29jayIsImdpdmVuIjpbIkpvaG4iXX1dLCJyZXNvdXJjZVR5cGUiOiJQcmFjdGl0aW9uZXIiLCJ0ZXh0Ijp7ImRpdiI6IjxkaXYgeG1sbnM9XCJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hodG1sXCI-PHA-PGI-R2VuZXJhdGVkIE5hcnJhdGl2ZTwvYj48L3A-PGRpdiBzdHlsZT1cImRpc3BsYXk6IGlubGluZS1ibG9jazsgYmFja2dyb3VuZC1jb2xvcjogI2Q5ZTBlNzsgcGFkZGluZzogNnB4OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQgIzhkYTFiNDsgYm9yZGVyLXJhZGl1czogNXB4OyBsaW5lLWhlaWdodDogNjAlXCI-PHAgc3R5bGU9XCJtYXJnaW4tYm90dG9tOiAwcHhcIj5SZXNvdXJjZSBcIjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliY1wiIFVwZGF0ZWQgXCIyMDEzLTA1LTA1VDE2OjEzOjAzWlwiIDwvcD48L2Rpdj48cD48Yj5uYW1lPC9iPjogSm9obiBIYW5jb2NrIDwvcD48L2Rpdj4iLCJzdGF0dXMiOiJnZW5lcmF0ZWQifX19LHsiZnVsbFVybCI6InVybjp1dWlkOjk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZSIsInJlc291cmNlIjp7ImFjdGl2ZSI6dHJ1ZSwiaWQiOiI5NzBhZjZjOS01YmJkLTQwNjctYjZjMS1kOWIyYzgyM2FlY2UiLCJuYW1lIjpbeyJmYW1pbHkiOiJQYXRpZW50IiwiZ2l2ZW4iOlsiQ0RFWCBFeGFtcGxlIl0sInRleHQiOiJDREVYIEV4YW1wbGUgUGF0aWVudCJ9XSwicmVzb3VyY2VUeXBlIjoiUGF0aWVudCIsInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiOTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlXCIgPC9wPjwvZGl2PjxwPjxiPmFjdGl2ZTwvYj46IHRydWU8L3A-PHA-PGI-bmFtZTwvYj46IENERVggRXhhbXBsZSBQYXRpZW50PC9wPjwvZGl2PiIsInN0YXR1cyI6ImdlbmVyYXRlZCJ9fX0seyJmdWxsVXJsIjoidXJuOnV1aWQ6MDE0YTY4ZWMtZDY5MS00OWUwLWI5ODAtOTFiMGQ5MjRlNTcwIiwicmVzb3VyY2UiOnsiYXNzZXJ0ZXIiOnsicmVmZXJlbmNlIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIn0sImNhdGVnb3J5IjpbeyJjb2RpbmciOlt7ImNvZGUiOiI1NTYwNzAwNiIsImRpc3BsYXkiOiJQcm9ibGVtIiwic3lzdGVtIjoiaHR0cDovL3Nub21lZC5pbmZvL3NjdCJ9LHsiY29kZSI6Ijc1MzI2LTkiLCJkaXNwbGF5IjoiUHJvYmxlbSIsInN5c3RlbSI6Imh0dHA6Ly9sb2luYy5vcmcifV19XSwiY2xpbmljYWxTdGF0dXMiOnsiY29kaW5nIjpbeyJjb2RlIjoiYWN0aXZlIiwic3lzdGVtIjoiaHR0cDovL3Rlcm1pbm9sb2d5LmhsNy5vcmcvQ29kZVN5c3RlbS9jb25kaXRpb24tY2xpbmljYWwifV19LCJjb2RlIjp7ImNvZGluZyI6W3siY29kZSI6IjQ0MDU0MDA2IiwiZGlzcGxheSI6IlR5cGUgMiBEaWFiZXRlcyBNZWxsaXR1cyIsInN5c3RlbSI6Imh0dHA6Ly9zbm9tZWQuaW5mby9zY3QifV19LCJpZCI6IjAxNGE2OGVjLWQ2OTEtNDllMC1iOTgwLTkxYjBkOTI0ZTU3MCIsImlkZW50aWZpZXIiOlt7InN5c3RlbSI6InVybjpvaWQ6MS4zLjYuMS40LjEuMjI4MTIuNC4xMTEuMC40LjEuMi4xIiwidmFsdWUiOiIxIn1dLCJvbnNldERhdGVUaW1lIjoiMjAwNiIsInJlc291cmNlVHlwZSI6IkNvbmRpdGlvbiIsInN1YmplY3QiOnsicmVmZXJlbmNlIjoidXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlIn0sInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiMDE0YTY4ZWMtZDY5MS00OWUwLWI5ODAtOTFiMGQ5MjRlNTcwXCIgPC9wPjwvZGl2PjxwPjxiPmlkZW50aWZpZXI8L2I-OiBpZDogMTwvcD48cD48Yj5jbGluaWNhbFN0YXR1czwvYj46IEFjdGl2ZSA8c3BhbiBzdHlsZT1cImJhY2tncm91bmQ6IExpZ2h0R29sZGVuUm9kWWVsbG93OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQga2hha2lcIj4gKDxhIGhyZWY9XCJodHRwOi8vdGVybWlub2xvZ3kuaGw3Lm9yZy8zLjAuMC9Db2RlU3lzdGVtLWNvbmRpdGlvbi1jbGluaWNhbC5odG1sXCI-Q29uZGl0aW9uIENsaW5pY2FsIFN0YXR1cyBDb2RlczwvYT4jYWN0aXZlKTwvc3Bhbj48L3A-PHA-PGI-Y2F0ZWdvcnk8L2I-OiBQcm9ibGVtIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vYnJvd3Nlci5paHRzZG90b29scy5vcmcvXCI-U05PTUVEIENUPC9hPiM1NTYwNzAwNjsgPGEgaHJlZj1cImh0dHBzOi8vbG9pbmMub3JnL1wiPkxPSU5DPC9hPiM3NTMyNi05KTwvc3Bhbj48L3A-PHA-PGI-Y29kZTwvYj46IFR5cGUgMiBEaWFiZXRlcyBNZWxsaXR1cyA8c3BhbiBzdHlsZT1cImJhY2tncm91bmQ6IExpZ2h0R29sZGVuUm9kWWVsbG93OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQga2hha2lcIj4gKDxhIGhyZWY9XCJodHRwczovL2Jyb3dzZXIuaWh0c2RvdG9vbHMub3JnL1wiPlNOT01FRCBDVDwvYT4jNDQwNTQwMDYpPC9zcGFuPjwvcD48cD48Yj5zdWJqZWN0PC9iPjogPGEgaHJlZj1cIiNQYXRpZW50Xzk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZVwiPlNlZSBhYm92ZSAodXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlKTwvYT48L3A-PHA-PGI-b25zZXQ8L2I-OiAyMDA2LTAxLTAxPC9wPjxwPjxiPmFzc2VydGVyPC9iPjogPGEgaHJlZj1cIiNQcmFjdGl0aW9uZXJfMDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjXCI-U2VlIGFib3ZlICh1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMpPC9hPjwvcD48L2Rpdj4iLCJzdGF0dXMiOiJnZW5lcmF0ZWQifX19LHsiZnVsbFVybCI6InVybjp1dWlkOjVjZTVjODNhLTAwMGYtNDdkMi05NDFjLTAzOTM1OGNjOTExMiIsInJlc291cmNlIjp7ImNsYXNzIjp7ImNvZGUiOiJFTUVSIiwic3lzdGVtIjoiaHR0cDovL3Rlcm1pbm9sb2d5LmhsNy5vcmcvQ29kZVN5c3RlbS92My1BY3RDb2RlIn0sImlkIjoiNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyIiwicGFydGljaXBhbnQiOlt7ImluZGl2aWR1YWwiOnsiZGlzcGxheSI6IkpvaG4gSGFuY29jayIsInJlZmVyZW5jZSI6InVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYyJ9fV0sInBlcmlvZCI6eyJlbmQiOiIyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwIiwic3RhcnQiOiIyMDIxLTEwLTI1VDIwOjEwOjI5LTA3OjAwIn0sInJlc291cmNlVHlwZSI6IkVuY291bnRlciIsInNlcnZpY2VQcm92aWRlciI6eyJkaXNwbGF5IjoiQ0RFWCBFeGFtcGxlIE9yZ2FuaXphdGlvbiIsInJlZmVyZW5jZSI6InVybjp1dWlkOmUzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhMyJ9LCJzdGF0dXMiOiJmaW5pc2hlZCIsInN1YmplY3QiOnsiZGlzcGxheSI6IkNERVggRXhhbXBsZSBQYXRpZW50IiwicmVmZXJlbmNlIjoidXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlIn0sInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyXCIgPC9wPjwvZGl2PjxwPjxiPnN0YXR1czwvYj46IGZpbmlzaGVkPC9wPjxwPjxiPmNsYXNzPC9iPjogZW1lcmdlbmN5IChEZXRhaWxzOiBodHRwOi8vdGVybWlub2xvZ3kuaGw3Lm9yZy9Db2RlU3lzdGVtL3YzLUFjdENvZGUgY29kZSBFTUVSID0gJ2VtZXJnZW5jeScsIHN0YXRlZCBhcyAnbnVsbCcpPC9wPjxwPjxiPnR5cGU8L2I-OiBVbmtub3duIChxdWFsaWZpZXIgdmFsdWUpIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vYnJvd3Nlci5paHRzZG90b29scy5vcmcvXCI-U05PTUVEIENUPC9hPiMyNjE2NjUwMDYpPC9zcGFuPjwvcD48cD48Yj5zdWJqZWN0PC9iPjogPGEgaHJlZj1cIiNQYXRpZW50Xzk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZVwiPlNlZSBhYm92ZSAodXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlOiBDREVYIEV4YW1wbGUgUGF0aWVudCk8L2E-PC9wPjxoMz5QYXJ0aWNpcGFudHM8L2gzPjx0YWJsZSBjbGFzcz1cImdyaWRcIj48dHI-PHRkPi08L3RkPjx0ZD48Yj5JbmRpdmlkdWFsPC9iPjwvdGQ-PC90cj48dHI-PHRkPio8L3RkPjx0ZD48YSBocmVmPVwiI1ByYWN0aXRpb25lcl8wODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmNcIj5TZWUgYWJvdmUgKHVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYzogSm9obiBIYW5jb2NrKTwvYT48L3RkPjwvdHI-PC90YWJsZT48cD48Yj5wZXJpb2Q8L2I-OiAyMDIxLTEwLTI1VDIwOjEwOjI5LTA3OjAwIC0tJmd0OyAyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwPC9wPjxwPjxiPnNlcnZpY2VQcm92aWRlcjwvYj46IDxhIGhyZWY9XCIjT3JnYW5pemF0aW9uX2UzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhM1wiPlNlZSBhYm92ZSAodXJuOnV1aWQ6ZTM3ZjAwNGItZGMxMC00MjJiLWI4MzMtY2RhYTEwYTA1NWEzOiBDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uKTwvYT48L3A-PC9kaXY-Iiwic3RhdHVzIjoiZ2VuZXJhdGVkIn0sInR5cGUiOlt7ImNvZGluZyI6W3siY29kZSI6IjI2MTY2NTAwNiIsImRpc3BsYXkiOiJVbmtub3duIChxdWFsaWZpZXIgdmFsdWUpIiwic3lzdGVtIjoiaHR0cDovL3Nub21lZC5pbmZvL3NjdCJ9XSwidGV4dCI6IlVua25vd24gKHF1YWxpZmllciB2YWx1ZSkifV19fSx7ImZ1bGxVcmwiOiJ1cm46dXVpZDplMzdmMDA0Yi1kYzEwLTQyMmItYjgzMy1jZGFhMTBhMDU1YTMiLCJyZXNvdXJjZSI6eyJhY3RpdmUiOnRydWUsImFkZHJlc3MiOlt7ImNpdHkiOiJCb3N0b24iLCJjb3VudHJ5IjoiVVNBIiwibGluZSI6WyIxIENERVggTGFuZSJdLCJwb3N0YWxDb2RlIjoiMDEwMDIiLCJzdGF0ZSI6Ik1BIn1dLCJpZCI6ImUzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhMyIsIm5hbWUiOiJDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uIiwicmVzb3VyY2VUeXBlIjoiT3JnYW5pemF0aW9uIiwidGVsZWNvbSI6W3sic3lzdGVtIjoicGhvbmUiLCJ2YWx1ZSI6IigrMSkgNTU1LTU1NS01NTU1In0seyJzeXN0ZW0iOiJlbWFpbCIsInZhbHVlIjoiY3VzdG9tZXItc2VydmljZUBleGFtcGxlLm9yZyJ9XSwidGV4dCI6eyJkaXYiOiI8ZGl2IHhtbG5zPVwiaHR0cDovL3d3dy53My5vcmcvMTk5OS94aHRtbFwiPjxwPjxiPkdlbmVyYXRlZCBOYXJyYXRpdmU8L2I-PC9wPjxkaXYgc3R5bGU9XCJkaXNwbGF5OiBpbmxpbmUtYmxvY2s7IGJhY2tncm91bmQtY29sb3I6ICNkOWUwZTc7IHBhZGRpbmc6IDZweDsgbWFyZ2luOiA0cHg7IGJvcmRlcjogMXB4IHNvbGlkICM4ZGExYjQ7IGJvcmRlci1yYWRpdXM6IDVweDsgbGluZS1oZWlnaHQ6IDYwJVwiPjxwIHN0eWxlPVwibWFyZ2luLWJvdHRvbTogMHB4XCI-UmVzb3VyY2UgXCJlMzdmMDA0Yi1kYzEwLTQyMmItYjgzMy1jZGFhMTBhMDU1YTNcIiA8L3A-PC9kaXY-PHA-PGI-YWN0aXZlPC9iPjogdHJ1ZTwvcD48cD48Yj5uYW1lPC9iPjogQ0RFWCBFeGFtcGxlIE9yZ2FuaXphdGlvbjwvcD48cD48Yj50ZWxlY29tPC9iPjogcGg6ICgrMSkgNTU1LTU1NS01NTU1LCA8YSBocmVmPVwibWFpbHRvOmN1c3RvbWVyLXNlcnZpY2VAZXhhbXBsZS5vcmdcIj5jdXN0b21lci1zZXJ2aWNlQGV4YW1wbGUub3JnPC9hPjwvcD48cD48Yj5hZGRyZXNzPC9iPjogMSBDREVYIExhbmUgQm9zdG9uIE1BIDAxMDAyIFVTQSA8L3A-PC9kaXY-Iiwic3RhdHVzIjoiZ2VuZXJhdGVkIn19fV0sImlkZW50aWZpZXIiOnsic3lzdGVtIjoidXJuOmlldGY6cmZjOjM5ODYiLCJ2YWx1ZSI6InVybjp1dWlkOmMxNzM1MzVlLTEzNWUtNDhlMy1hYjY0LTM4YmFjYzY4ZGJhOCJ9LCJyZXNvdXJjZVR5cGUiOiJCdW5kbGUiLCJ0aW1lc3RhbXAiOiIyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwIiwidHlwZSI6ImRvY3VtZW50In0.JAET6A3W8KXfOYOE-gM4yfSmN0uMInsj3CrMUtQRcOKZ4V4I9-aZxavMXUnuoIznKj9rBir-O8tFCfjbLjrkXv4SVVuuLiFOW4YigjRYH_Dg4LuwiT72kYGoRYVH14rqSVYCOEBVnWAVT25xAJ05Lu5z2Z5JQ5ReuLIjXd8rSYZbpLaF8jBxKWFBo_L2_6RtqTdNo3OkRYgtP5NgiwtOIyoWBw-XBaXAtFtNdWCU14vOk_tJJ0Sg6lYojE881qWUsi1BgFWfswa1xJXIa8XcpA_-kdTvlYiO2ZJOqXuyJt2_xjA9AV4mx3Tmmxl7q6xcgyOlQBKLBUWJUGET_1ddHdVV6uIC_93OyO9FL_Szw3iWElGLtXerLbEHGlDmR8OJU--NaJCeyDVnbYAeLEkeSu6Kpc0K_nrZzvr8Rn-_nI3C1UjXSN24th_sOkYbQ63NsFgifJlyY8uLS-uu6jWd3Wadydq7J6haX9BB9wtB0bRWzqYutvCYlvygxzFAD9ui'
</pre>




```python
!openssl x509 -in recd_cert.der -inform DER -pubkey -noout > recd-public-key.pem
with open('recd-public-key.pem') as f:
<pre style="border:0; overflow-wrap:break-word;">
pem_public = f.read()
</pre>
pem_public
```




<pre style="border:0; overflow-wrap:break-word;">
'-----BEGIN PUBLIC KEY-----\nMIIBojANBgkqhkiG9w0BAQEFAAOCAY8AMIIBigKCAYEA6SnEpKADOrFttfr1k3iF\nThsddDFmrEMu1R4nes8qlwATPs53wZ13p8lNI9RU7z5kXzg6Dg11bj1MA6JoQh4f\nm3JVvSjNqOet3MUShLwZ2h67I8OcjZsTuWIxEW4bR3UHqpLXcN1WBEUfR6MSztxZ\nLM0dvdh0weMVt8lpVd4E5DEKMz0nCSh92xvD6qugGDyewuGASJVEnQTFZd6p3hH4\nO37sYhX16H3U1Zu6zIohu1/c+Nz34pamnorH5rUcQJUcBDV6x9zrzgz8i9K05xvA\nrGwF2FSDJnXR3uGRfaZYfebI+KTE4S7XCV/6PVxy44exJmcoCR1hEKuD8BcGXZm3\nH4Qpjq/PB/AW1K7v+1es27BtTdQlpZ3ZW1c5y/tyDDq/JF2h3Gp6n3JIBVeBK534\nxSatTiGgJrDI/OcTJI8ly8nCy/7uZ9qOgYPd/1EX6rjqEiBjgkduQ2mc6cNpN7O6\nBPXTMBFl7X14GLYdm5Y8ubRR9Bo6TpMdO4+2U+R58Z5bAgMBAAE=\n-----END PUBLIC KEY-----\n'
</pre>




```python
try:
    verify = jws.verify(recd_jws, pem_public , algorithms=['RS256'])
    print('#     #                                                ### ')
    print('#     #  ######  #####   #  ######  #  ######  #####   ### ')
    print('#     #  #       #    #  #  #       #  #       #    #  ### ')
    print('#     #  #####   #    #  #  #####   #  #####   #    #   #  ')
    print(' #   #   #       #####   #  #       #  #       #    #      ')
    print('  # #    #       #   #   #  #       #  #       #    #  ### ')
    print('   #     ######  #    #  #  #       #  ######  #####   ### ')
    print('                                                           ')

except Exception as e:
    print('#    #   ####   #####      #    #  ######  #####   #  ######  #  ######  #####       ###          #   ')
    print('##   #  #    #    #        #    #  #       #    #  #  #       #  #       #    #       #          #    ')
    print('# #  #  #    #    #        #    #  #####   #    #  #  #####   #  #####   #    #           #####  #    ')
    print('#  # #  #    #    #        #    #  #       #####   #  #       #  #       #    #       #          #    ')
    print('#   ##  #    #    #         #  #   #       #   #   #  #       #  #       #    #      ###          #   ')
    print('#    #   ####     #          ##    ######  #    #  #  #       #  ######  #####        #            ## ')
    print('                ')
    print(f"not verified: {e}")
```

<pre style="border:0; overflow-wrap:break-word;">
#     #                                                ###
#     #  ######  #####   #  ######  #  ######  #####   ###
#     #  #       #    #  #  #       #  #       #    #  ###
#     #  #####   #    #  #  #####   #  #####   #    #   #  
 #   #   #       #####   #  #       #  #       #    #      
  # #    #       #   #   #  #       #  #       #    #  ###
   #     ######  #    #  #  #       #  ######  #####   ###
</pre>
