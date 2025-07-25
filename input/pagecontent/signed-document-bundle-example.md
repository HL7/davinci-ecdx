<div class="bg-success" markdown="1">

<!-- # Da Vinci CDEX Digital Signature Document Bundle Example -->

This is a Jupyter Notebook which uses openSSL, Python 3.7, and the Python jcs and jose libraries to create a JSON Web Signature (JWS) (see RFC 7515), attach it to a FHIR Bundle and validate it. Its source code be found [here](https://github.com/HL7/davinci-ecdx/blob/master/CDEX-Signatures/Digsig_Document_Bundle_Example.ipynb)


*Although self-signed certificates are used for the purpose of these examples, they are not recommended for production systems.*

### Sender/Signer Steps

**1. Generate RSA256 public and private keys for signing the bundle**

*DO THIS STEP ONLY ONCE*

**2. Create a sef-signed certificate for authenticating the signer**

create the public and private keys and cert using openssl on the command line.

1. pre-configure the self-signed cert with a configuration file

~~~
[req]
default_bit = 4096
distinguished_name = req_distinguished_name
prompt = no
x509_extensions = v3_ca

# Subject details
[req_distinguished_name]
countryName             = US
stateOrProvinceName     = California
localityName            = Sausalito
organizationName        = Example Organization
commonName              = John Hancock, MD
emailAddress            = jhancock@example.org

[v3_ca]
basicConstraints = CA:FALSE
keyUsage=nonRepudiation, digitalSignature, keyEncipherment
# 1.2.840.113549.1.9.16.2.47 = ASN1:SEQUENCE:commitment_type  # custom extensio

# SAN extension
subjectAltName = @alt_names

# SAN entries for FHIR and NPI
[alt_names]
DNS.1 = www.example.org
otherName.1 = 2.16.840.1.113883.4.6;UTF8:9941339100
URI.1 = https://example.org/fhir/Practitioner/123
~~~

2\. generate the public and private keys and cert

~~~
!openssl genrsa -out private-key.pem 3072
!openssl rsa -in private-key.pem -pubout -out public-key.pem
!openssl req -new -x509 -key private-key.pem -outform DER -out cert.der -days 360 -config cert.config
~~~

##### For the purpose of this example display the keys (normally would never share the private key)


```python
!cat private-key.pem
!echo
!cat public-key.pem
```
<pre  style="border:0; background:white; overflow-wrap:break-word;">
    -----BEGIN PRIVATE KEY-----
    MIIG/wIBADANBgkqhkiG9w0BAQEFAASCBukwggblAgEAAoIBgQCu3Ich4SabUyLa
    JHuVFb00/EDJL0GHw/ETVsUo9tGjUFZ0ViiwMAMxzF2H2O7JyyKEUSb+32dwF4F4
    sjVS7MRv8r4VbVomd+T5pnMDbWmDXPStGPuJKGkrDx/RqKHNpOJoE6VKxyhgNZ4H
    Lul7lD94vtVG6qCVmFWTtktKnDzFtVOgU9jLYiHnrCZ3jH7Dgj0NIKyaIQTXC1a5
    m15WWB5x8yxj9fOjMcFOSTgWuHw/GP/eS9hNhTnaOxzMAgsOWlQriBrtcYyjbdCi
    5d0VdYjwozpd85FYKpZT7ZXgH0yeOMbyOs744IMdAcmoHGuQxhb4aRuEGrxg6eBB
    Af+1nwKPy9/RlcRCi7QtaahU19li6oIYMnkiDSUAOab6UHC1J4z0+mOrR9Vfj+77
    6ijfotiKfA2gECbetCUE0jkxTBU6uu86GJZ1i9hKPd/AKRvVooGh8Wo8yvf+dL7d
    U4uAanu/tq0JN9Ybt/F/kTy+HbvLWOrcU8o9jTSs3CzpXdBm41cCAwEAAQKCAYBJ
    JUG3x92k8sFs+/7gLdBQdkbJgaWJW8sf+leOG7U0+jm3/4SUsvjbH3Buj63PptQh
    AmtsCVrVFlgX+3/32MgRRjsCbpRb7CJR1jFdWSregwds0zsBNHDNzM1UIBTTF6qH
    u9QUdDvtBvC8c4DCq5Bje3xu5l3XRfpiSEq1gqafU4sQUZKp/TpOlYIf1xr9wKC2
    OZlJ/g7uv7T+/kGXn9PYec7zX6KTfRAuJc27H2AF6vi5bgOk5dp98eVJZ39leR3z
    kfuAB3lAvLbWVbMhx0piXQ7z4T4xRaKGyJ6plk6nyONhp4qIz84l6mfVhrzr1SET
    fdXetyUxzgHLd+lIPD4Ggx6B22u3h+0TXe12vzJYTOJASyslq0XGoqK/bl/ruplw
    z5EirSAV2XInZPGjCuL82KfKOZxy1iQUhV1htfowYB26wQTlQyGfB+0U5QO5YgS7
    2psK0ScX5Wzo6tfC1rtN9wJpSnm/USKWtVObth4iYlshnvvIGh8fi6Zuo0XyKbUC
    gcEA6fTarXF2/Dt8UmkAXsrnmapO4xk5kbBHakYYkYkVBVf2D1uRrsdhCc01PSz6
    q06qyvkei5PqGujOwDYYcMQ+1ZGbphdxCTXZR614NXS6fYgpEA11YEH0Wa1eR5i8
    lmAvGfwOZWt9BVNPLaD45pXMOwm31Hh49z0NjfcJb8K5uxf7k1EofyjXnPgkm6Fq
    u92QAFLx9gwIC6/3t2Dw4SZ7tnIbCZs2s748swlibynxrSfVXM21pChAhDcm7Ej1
    sUT7AoHBAL9WRboJLWJM27d8pc9sMHkajYUwOZSRLeAMcvjwE1+tVodECIotiYtG
    RLxzqPUF+XxLSALxdEpVzmZLAJQdxvTAwPb9kzRe7kRAOwq60Z5QcjSrZT+gLKsx
    zHQpDRaWzCYb+ju2YOgMyPXdV1Lm9SUbMfYa8GRgMzTSeZi0+NjrjzKko5Mc5dQG
    cNrcVguqnl1NhMMb8iM87vGxn3xQJwHMkTYWOS8DkqagxfSi82k+CSrYNc4FLzwf
    E9pf2Rg0VQKBwQCxAcAxWZdcXuVAtJDDJ2DyshfdWkhkIarmjQIpmj19PX+9PtqK
    Ee8pK0kMb+t3kJ1H1BN4JwEIOvuyETuMle20R+YrU7EB9uvdfzFjwF0YfNwUeRpF
    KaFl9/VM1hJY84yvbDS4Jwr/7HgLXa7zRoKuaDvdVQiwhlCrCCzrkbhUBWEhpFWv
    X4dCC7wmw4mteYRpule2gIPV09znsUCOGD+hWdN7ASPx+gySqJcA5Aslpu2WuUyk
    Vo/5eIDKZKj+5eECgcEAmVPjUG+mRM3ejK2AmjXSqlmS6xZ4LgwhPRf80mxguh1H
    5+GnDkProwZOcs4kqSV+hhI1xNYFIMSeP+7+qbMrClukxsjxu9gPC/aE2dZXwIwq
    2PY4jsImyZGAi92RtXZmZmupHUzLX2lPaWdUYQTfkjq20MdJuMY2gq/f7XWorPwn
    pqe0xWE087GtolVLRtIVUiOarleotIBR4rE6Yv5AI/rwqu0oKfqs/IZ928rxUHb8
    Fa9pfo09CurEmAyTBgh5AoHBAL1DOIEpT0a2DCGREJrR8GwqkqpW9tiYOmc/6KQV
    VJ44pRd8g9xRYvReg8fnpnj2vNr8TK6OhH13CMscO1GWOydW3Fn7VqK5J9/5imkM
    fVHJ9la+Fh2uGCbsqK+etmaRTf+O43b8rfQtJx0HuOKugAGG7tkj4YCDB2zsP2HS
    l7btElZnlqgZtl0tVmT0FxLgMeLIZbtC/8+ecVWWlgsZk6q/ckeIA0TXoDQuZ/5F
    2q/lprgQWdm+cxzJBhU7fD7eGQ==
    -----END PRIVATE KEY-----
    
    -----BEGIN PUBLIC KEY-----
    MIIBojANBgkqhkiG9w0BAQEFAAOCAY8AMIIBigKCAYEArtyHIeEmm1Mi2iR7lRW9
    NPxAyS9Bh8PxE1bFKPbRo1BWdFYosDADMcxdh9juycsihFEm/t9ncBeBeLI1UuzE
    b/K+FW1aJnfk+aZzA21pg1z0rRj7iShpKw8f0aihzaTiaBOlSscoYDWeBy7pe5Q/
    eL7VRuqglZhVk7ZLSpw8xbVToFPYy2Ih56wmd4x+w4I9DSCsmiEE1wtWuZteVlge
    cfMsY/XzozHBTkk4Frh8Pxj/3kvYTYU52jsczAILDlpUK4ga7XGMo23QouXdFXWI
    8KM6XfORWCqWU+2V4B9MnjjG8jrO+OCDHQHJqBxrkMYW+GkbhBq8YOngQQH/tZ8C
    j8vf0ZXEQou0LWmoVNfZYuqCGDJ5Ig0lADmm+lBwtSeM9Ppjq0fVX4/u++oo36LY
    inwNoBAm3rQlBNI5MUwVOrrvOhiWdYvYSj3fwCkb1aKBofFqPMr3/nS+3VOLgGp7
    v7atCTfWG7fxf5E8vh27y1jq3FPKPY00rNws6V3QZuNXAgMBAAE=
    -----END PUBLIC KEY-----
</pre>

Show the Certificate in DER Format


```python
!openssl x509 -in cert.der -inform DER -text
```
<pre  style="border:0; background:white; overflow-wrap:break-word;">
    Certificate:
        Data:
            Version: 3 (0x2)
            Serial Number:
                39:c1:6a:2c:e0:66:b7:b5:51:eb:2e:05:1a:7d:34:41:21:4c:5c:98
            Signature Algorithm: sha256WithRSAEncryption
            Issuer: C=US, ST=Massachusetts, L=Boston, O=Example Organization, CN=CDEX Example Organization, emailAddress=customer-service@example.org
            Validity
                Not Before: Jul 24 18:14:40 2025 GMT
                Not After : Jul 19 18:14:40 2026 GMT
            Subject: C=US, ST=Massachusetts, L=Boston, O=Example Organization, CN=CDEX Example Organization, emailAddress=customer-service@example.org
            Subject Public Key Info:
                Public Key Algorithm: rsaEncryption
                    Public-Key: (3072 bit)
                    Modulus:
                        00:ae:dc:87:21:e1:26:9b:53:22:da:24:7b:95:15:
                        bd:34:fc:40:c9:2f:41:87:c3:f1:13:56:c5:28:f6:
                        d1:a3:50:56:74:56:28:b0:30:03:31:cc:5d:87:d8:
                        ee:c9:cb:22:84:51:26:fe:df:67:70:17:81:78:b2:
                        35:52:ec:c4:6f:f2:be:15:6d:5a:26:77:e4:f9:a6:
                        73:03:6d:69:83:5c:f4:ad:18:fb:89:28:69:2b:0f:
                        1f:d1:a8:a1:cd:a4:e2:68:13:a5:4a:c7:28:60:35:
                        9e:07:2e:e9:7b:94:3f:78:be:d5:46:ea:a0:95:98:
                        55:93:b6:4b:4a:9c:3c:c5:b5:53:a0:53:d8:cb:62:
                        21:e7:ac:26:77:8c:7e:c3:82:3d:0d:20:ac:9a:21:
                        04:d7:0b:56:b9:9b:5e:56:58:1e:71:f3:2c:63:f5:
                        f3:a3:31:c1:4e:49:38:16:b8:7c:3f:18:ff:de:4b:
                        d8:4d:85:39:da:3b:1c:cc:02:0b:0e:5a:54:2b:88:
                        1a:ed:71:8c:a3:6d:d0:a2:e5:dd:15:75:88:f0:a3:
                        3a:5d:f3:91:58:2a:96:53:ed:95:e0:1f:4c:9e:38:
                        c6:f2:3a:ce:f8:e0:83:1d:01:c9:a8:1c:6b:90:c6:
                        16:f8:69:1b:84:1a:bc:60:e9:e0:41:01:ff:b5:9f:
                        02:8f:cb:df:d1:95:c4:42:8b:b4:2d:69:a8:54:d7:
                        d9:62:ea:82:18:32:79:22:0d:25:00:39:a6:fa:50:
                        70:b5:27:8c:f4:fa:63:ab:47:d5:5f:8f:ee:fb:ea:
                        28:df:a2:d8:8a:7c:0d:a0:10:26:de:b4:25:04:d2:
                        39:31:4c:15:3a:ba:ef:3a:18:96:75:8b:d8:4a:3d:
                        df:c0:29:1b:d5:a2:81:a1:f1:6a:3c:ca:f7:fe:74:
                        be:dd:53:8b:80:6a:7b:bf:b6:ad:09:37:d6:1b:b7:
                        f1:7f:91:3c:be:1d:bb:cb:58:ea:dc:53:ca:3d:8d:
                        34:ac:dc:2c:e9:5d:d0:66:e3:57
                    Exponent: 65537 (0x10001)
            X509v3 extensions:
                X509v3 Basic Constraints: 
                    CA:FALSE
                X509v3 Key Usage: 
                    Digital Signature, Non Repudiation, Key Encipherment
                X509v3 Subject Alternative Name: 
                    DNS:www.example.org, othername: 2.16.840.1.113883.4.6:1234567893, URI:https://example.org/fhir/Organization/123
                X509v3 Subject Key Identifier: 
                    E6:EF:DB:35:0B:69:B3:69:A4:3A:E6:01:54:E1:7F:39:AC:75:EB:58
        Signature Algorithm: sha256WithRSAEncryption
        Signature Value:
            18:8b:39:4d:fd:34:4c:92:cd:94:86:cf:66:8d:85:b3:33:51:
            5e:51:69:3c:2b:a4:3c:43:bd:88:c3:5f:78:c4:3f:f8:ec:9a:
            3e:3f:a4:df:8b:e5:16:01:5e:c0:5f:63:14:94:b9:b4:0b:79:
            5b:e4:7f:97:ef:fa:81:ab:99:e0:96:f9:f5:fc:c8:4d:6b:97:
            ea:bc:d4:20:8b:f9:0f:0b:38:ec:c0:64:5b:84:79:81:3d:89:
            e7:33:63:b7:ce:d7:c3:29:17:c9:c2:d7:80:83:41:be:83:37:
            5d:10:68:0b:5b:85:31:5a:91:97:8e:a9:96:94:81:3a:03:7c:
            83:6c:9f:b8:f3:6b:f6:e9:b7:52:9e:bb:9b:d4:b2:ed:6a:16:
            08:c0:a7:30:3a:f8:c6:a5:20:d5:24:1e:66:b6:14:af:b3:d9:
            87:f2:d1:6f:cd:86:ea:5b:2d:c5:84:9f:54:72:b9:40:53:43:
            0b:2c:9b:dc:11:3c:31:3f:2e:84:94:03:7a:66:9a:a3:c3:97:
            ce:dd:f6:d1:85:0c:af:f2:95:04:ee:6a:a9:79:b4:5d:36:96:
            3c:fc:c1:84:22:49:17:f9:9f:3c:6a:4e:6b:67:30:29:af:87:
            26:b1:ef:99:f9:d2:da:3f:4e:7e:25:87:f8:f5:8a:4a:3e:c0:
            20:16:4c:c0:8d:91:bf:a6:e0:6d:66:b1:da:14:62:71:18:9f:
            f4:e2:cd:6f:6f:2b:72:e1:55:35:b9:65:d2:3e:b9:5c:9a:b1:
            d0:61:44:ba:32:97:06:22:75:41:82:6a:1b:c9:7c:34:86:93:
            4c:52:ef:88:54:5d:bd:b6:dc:09:b3:89:22:84:dd:31:4f:c5:
            29:d9:12:fd:f3:8b:c9:8e:93:3b:0c:4a:e6:e3:9e:92:6a:ae:
            74:17:a0:19:cd:23:cb:3e:8f:42:32:65:0d:bd:66:67:7c:08:
            b2:ea:9a:09:08:39:53:ae:69:c0:a8:91:7b:ca:0d:69:14:9a:
            40:72:44:ee:8b:c0
    -----BEGIN CERTIFICATE-----
    MIIFeTCCA+GgAwIBAgIUOcFqLOBmt7VR6y4FGn00QSFMXJgwDQYJKoZIhvcNAQEL
    BQAwgaYxCzAJBgNVBAYTAlVTMRYwFAYDVQQIDA1NYXNzYWNodXNldHRzMQ8wDQYD
    VQQHDAZCb3N0b24xHTAbBgNVBAoMFEV4YW1wbGUgT3JnYW5pemF0aW9uMSIwIAYD
    VQQDDBlDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uMSswKQYJKoZIhvcNAQkBFhxj
    dXN0b21lci1zZXJ2aWNlQGV4YW1wbGUub3JnMB4XDTI1MDcyNDE4MTQ0MFoXDTI2
    MDcxOTE4MTQ0MFowgaYxCzAJBgNVBAYTAlVTMRYwFAYDVQQIDA1NYXNzYWNodXNl
    dHRzMQ8wDQYDVQQHDAZCb3N0b24xHTAbBgNVBAoMFEV4YW1wbGUgT3JnYW5pemF0
    aW9uMSIwIAYDVQQDDBlDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uMSswKQYJKoZI
    hvcNAQkBFhxjdXN0b21lci1zZXJ2aWNlQGV4YW1wbGUub3JnMIIBojANBgkqhkiG
    9w0BAQEFAAOCAY8AMIIBigKCAYEArtyHIeEmm1Mi2iR7lRW9NPxAyS9Bh8PxE1bF
    KPbRo1BWdFYosDADMcxdh9juycsihFEm/t9ncBeBeLI1UuzEb/K+FW1aJnfk+aZz
    A21pg1z0rRj7iShpKw8f0aihzaTiaBOlSscoYDWeBy7pe5Q/eL7VRuqglZhVk7ZL
    Spw8xbVToFPYy2Ih56wmd4x+w4I9DSCsmiEE1wtWuZteVlgecfMsY/XzozHBTkk4
    Frh8Pxj/3kvYTYU52jsczAILDlpUK4ga7XGMo23QouXdFXWI8KM6XfORWCqWU+2V
    4B9MnjjG8jrO+OCDHQHJqBxrkMYW+GkbhBq8YOngQQH/tZ8Cj8vf0ZXEQou0LWmo
    VNfZYuqCGDJ5Ig0lADmm+lBwtSeM9Ppjq0fVX4/u++oo36LYinwNoBAm3rQlBNI5
    MUwVOrrvOhiWdYvYSj3fwCkb1aKBofFqPMr3/nS+3VOLgGp7v7atCTfWG7fxf5E8
    vh27y1jq3FPKPY00rNws6V3QZuNXAgMBAAGjgZwwgZkwCQYDVR0TBAIwADALBgNV
    HQ8EBAMCBeAwYAYDVR0RBFkwV4IPd3d3LmV4YW1wbGUub3JnoBkGCWCGSAGG+VsE
    BqAMDAoxMjM0NTY3ODkzhilodHRwczovL2V4YW1wbGUub3JnL2ZoaXIvT3JnYW5p
    emF0aW9uLzEyMzAdBgNVHQ4EFgQU5u/bNQtps2mkOuYBVOF/Oax161gwDQYJKoZI
    hvcNAQELBQADggGBABiLOU39NEySzZSGz2aNhbMzUV5RaTwrpDxDvYjDX3jEP/js
    mj4/pN+L5RYBXsBfYxSUubQLeVvkf5fv+oGrmeCW+fX8yE1rl+q81CCL+Q8LOOzA
    ZFuEeYE9ieczY7fO18MpF8nC14CDQb6DN10QaAtbhTFakZeOqZaUgToDfINsn7jz
    a/bpt1Keu5vUsu1qFgjApzA6+MalINUkHma2FK+z2Yfy0W/NhupbLcWEn1RyuUBT
    Qwssm9wRPDE/LoSUA3pmmqPDl87d9tGFDK/ylQTuaql5tF02ljz8wYQiSRf5nzxq
    TmtnMCmvhyax75n50to/Tn4lh/j1iko+wCAWTMCNkb+m4G1msdoUYnEYn/TizW9v
    K3LhVTW5ZdI+uVyasdBhRLoylwYidUGCahvJfDSGk0xS74hUXb223AmziSKE3TFP
    xSnZEv3zi8mOkzsMSubjnpJqrnQXoBnNI8s+j0IyZQ29Zmd8CLLqmgkIOVOuacCo
    kXvKDWkUmkByRO6LwA==
    -----END CERTIFICATE-----
</pre>

Show the Certicate in PEM format


```python
!openssl x509 -in cert.der -inform DER -outform PEM -out cert.pem
!cat cert.pem
```
<pre  style="border:0; background:white; overflow-wrap:break-word;">
    -----BEGIN CERTIFICATE-----
    MIIFeTCCA+GgAwIBAgIUOcFqLOBmt7VR6y4FGn00QSFMXJgwDQYJKoZIhvcNAQEL
    BQAwgaYxCzAJBgNVBAYTAlVTMRYwFAYDVQQIDA1NYXNzYWNodXNldHRzMQ8wDQYD
    VQQHDAZCb3N0b24xHTAbBgNVBAoMFEV4YW1wbGUgT3JnYW5pemF0aW9uMSIwIAYD
    VQQDDBlDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uMSswKQYJKoZIhvcNAQkBFhxj
    dXN0b21lci1zZXJ2aWNlQGV4YW1wbGUub3JnMB4XDTI1MDcyNDE4MTQ0MFoXDTI2
    MDcxOTE4MTQ0MFowgaYxCzAJBgNVBAYTAlVTMRYwFAYDVQQIDA1NYXNzYWNodXNl
    dHRzMQ8wDQYDVQQHDAZCb3N0b24xHTAbBgNVBAoMFEV4YW1wbGUgT3JnYW5pemF0
    aW9uMSIwIAYDVQQDDBlDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uMSswKQYJKoZI
    hvcNAQkBFhxjdXN0b21lci1zZXJ2aWNlQGV4YW1wbGUub3JnMIIBojANBgkqhkiG
    9w0BAQEFAAOCAY8AMIIBigKCAYEArtyHIeEmm1Mi2iR7lRW9NPxAyS9Bh8PxE1bF
    KPbRo1BWdFYosDADMcxdh9juycsihFEm/t9ncBeBeLI1UuzEb/K+FW1aJnfk+aZz
    A21pg1z0rRj7iShpKw8f0aihzaTiaBOlSscoYDWeBy7pe5Q/eL7VRuqglZhVk7ZL
    Spw8xbVToFPYy2Ih56wmd4x+w4I9DSCsmiEE1wtWuZteVlgecfMsY/XzozHBTkk4
    Frh8Pxj/3kvYTYU52jsczAILDlpUK4ga7XGMo23QouXdFXWI8KM6XfORWCqWU+2V
    4B9MnjjG8jrO+OCDHQHJqBxrkMYW+GkbhBq8YOngQQH/tZ8Cj8vf0ZXEQou0LWmo
    VNfZYuqCGDJ5Ig0lADmm+lBwtSeM9Ppjq0fVX4/u++oo36LYinwNoBAm3rQlBNI5
    MUwVOrrvOhiWdYvYSj3fwCkb1aKBofFqPMr3/nS+3VOLgGp7v7atCTfWG7fxf5E8
    vh27y1jq3FPKPY00rNws6V3QZuNXAgMBAAGjgZwwgZkwCQYDVR0TBAIwADALBgNV
    HQ8EBAMCBeAwYAYDVR0RBFkwV4IPd3d3LmV4YW1wbGUub3JnoBkGCWCGSAGG+VsE
    BqAMDAoxMjM0NTY3ODkzhilodHRwczovL2V4YW1wbGUub3JnL2ZoaXIvT3JnYW5p
    emF0aW9uLzEyMzAdBgNVHQ4EFgQU5u/bNQtps2mkOuYBVOF/Oax161gwDQYJKoZI
    hvcNAQELBQADggGBABiLOU39NEySzZSGz2aNhbMzUV5RaTwrpDxDvYjDX3jEP/js
    mj4/pN+L5RYBXsBfYxSUubQLeVvkf5fv+oGrmeCW+fX8yE1rl+q81CCL+Q8LOOzA
    ZFuEeYE9ieczY7fO18MpF8nC14CDQb6DN10QaAtbhTFakZeOqZaUgToDfINsn7jz
    a/bpt1Keu5vUsu1qFgjApzA6+MalINUkHma2FK+z2Yfy0W/NhupbLcWEn1RyuUBT
    Qwssm9wRPDE/LoSUA3pmmqPDl87d9tGFDK/ylQTuaql5tF02ljz8wYQiSRf5nzxq
    TmtnMCmvhyax75n50to/Tn4lh/j1iko+wCAWTMCNkb+m4G1msdoUYnEYn/TizW9v
    K3LhVTW5ZdI+uVyasdBhRLoylwYidUGCahvJfDSGk0xS74hUXb223AmziSKE3TFP
    xSnZEv3zi8mOkzsMSubjnpJqrnQXoBnNI8s+j0IyZQ29Zmd8CLLqmgkIOVOuacCo
    kXvKDWkUmkByRO6LwA==
    -----END CERTIFICATE-----
</pre>

**3. Create JWS to Attach to Bundle**

**3.1. Prepare Header**

- SHALL include an "alg" parameter for the JSON Web Algorithms (JWA) (see RFC 7518). "alg": "RS256" is preferred.
- SHALL include a "kty" parameter corresponding to the cryptographic algorithm family in "alg" ( e.g., "kty": "RSA" for "alg": "RS256" ).
- - SHALL include a "srCms" signer commitments.
- SHALL include a "sigT" header parameter with a timestamp of the signature.
- MAY include a "kid"
- SHALL have "x5c" (X.509 certificate chain) equal to an array of one or more base64-encoded (not base64url-encoded) DER representations of the public certificate or certificate chain (see RFC 7517). The public key is listed in the first certificate in the "x5c" specified by the entry's "Modulus" and "Exponent" parameters.

 note the base64 DER is Cert PEM file wihout the footer and header and line returns


```python
with open('cert.pem') as f:
    der = (f.read())  # base64 DER is PEM wihout the footer and header and line returns
der = der.replace('-----BEGIN CERTIFICATE-----','')
der = der.replace('-----END CERTIFICATE-----','')
der = der.replace('\n','')
```


```python
header = {
 'alg': 'RS256',
 'kty': 'RS',
 'srCms': [{'commId': {'id': 'urn:oid:1.2.840.10065.1.12.1.5',
    'desc': 'Verification Signature'},
   'commQuals': ['Verification of medical record integrity']}],
 'sigT': '2020-10-23T04:54:56.048+00:00',
 'kid': 'e6efdb350b69b369a43ae60154e17f39ac75eb58',
 'x5c': [der]
}
header
```



<pre  style="border:0; background:white; overflow-wrap:break-word;">
    {'alg': 'RS256',
     'kty': 'RS',
     'srCms': [{'commId': {'id': 'urn:oid:1.2.840.10065.1.12.1.5',
        'desc': 'Verification Signature'},
       'commQuals': ['Verification of medical record integrity']}],
     'sigT': '2020-10-23T04:54:56.048+00:00',
     'kid': 'e6efdb350b69b369a43ae60154e17f39ac75eb58',
     'x5c': ['MIIFeTCCA+GgAwIBAgIUOcFqLOBmt7VR6y4FGn00QSFMXJgwDQYJKoZIhvcNAQELBQAwgaYxCzAJBgNVBAYTAlVTMRYwFAYDVQQIDA1NYXNzYWNodXNldHRzMQ8wDQYDVQQHDAZCb3N0b24xHTAbBgNVBAoMFEV4YW1wbGUgT3JnYW5pemF0aW9uMSIwIAYDVQQDDBlDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uMSswKQYJKoZIhvcNAQkBFhxjdXN0b21lci1zZXJ2aWNlQGV4YW1wbGUub3JnMB4XDTI1MDcyNDE4MTQ0MFoXDTI2MDcxOTE4MTQ0MFowgaYxCzAJBgNVBAYTAlVTMRYwFAYDVQQIDA1NYXNzYWNodXNldHRzMQ8wDQYDVQQHDAZCb3N0b24xHTAbBgNVBAoMFEV4YW1wbGUgT3JnYW5pemF0aW9uMSIwIAYDVQQDDBlDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uMSswKQYJKoZIhvcNAQkBFhxjdXN0b21lci1zZXJ2aWNlQGV4YW1wbGUub3JnMIIBojANBgkqhkiG9w0BAQEFAAOCAY8AMIIBigKCAYEArtyHIeEmm1Mi2iR7lRW9NPxAyS9Bh8PxE1bFKPbRo1BWdFYosDADMcxdh9juycsihFEm/t9ncBeBeLI1UuzEb/K+FW1aJnfk+aZzA21pg1z0rRj7iShpKw8f0aihzaTiaBOlSscoYDWeBy7pe5Q/eL7VRuqglZhVk7ZLSpw8xbVToFPYy2Ih56wmd4x+w4I9DSCsmiEE1wtWuZteVlgecfMsY/XzozHBTkk4Frh8Pxj/3kvYTYU52jsczAILDlpUK4ga7XGMo23QouXdFXWI8KM6XfORWCqWU+2V4B9MnjjG8jrO+OCDHQHJqBxrkMYW+GkbhBq8YOngQQH/tZ8Cj8vf0ZXEQou0LWmoVNfZYuqCGDJ5Ig0lADmm+lBwtSeM9Ppjq0fVX4/u++oo36LYinwNoBAm3rQlBNI5MUwVOrrvOhiWdYvYSj3fwCkb1aKBofFqPMr3/nS+3VOLgGp7v7atCTfWG7fxf5E8vh27y1jq3FPKPY00rNws6V3QZuNXAgMBAAGjgZwwgZkwCQYDVR0TBAIwADALBgNVHQ8EBAMCBeAwYAYDVR0RBFkwV4IPd3d3LmV4YW1wbGUub3JnoBkGCWCGSAGG+VsEBqAMDAoxMjM0NTY3ODkzhilodHRwczovL2V4YW1wbGUub3JnL2ZoaXIvT3JnYW5pemF0aW9uLzEyMzAdBgNVHQ4EFgQU5u/bNQtps2mkOuYBVOF/Oax161gwDQYJKoZIhvcNAQELBQADggGBABiLOU39NEySzZSGz2aNhbMzUV5RaTwrpDxDvYjDX3jEP/jsmj4/pN+L5RYBXsBfYxSUubQLeVvkf5fv+oGrmeCW+fX8yE1rl+q81CCL+Q8LOOzAZFuEeYE9ieczY7fO18MpF8nC14CDQb6DN10QaAtbhTFakZeOqZaUgToDfINsn7jza/bpt1Keu5vUsu1qFgjApzA6+MalINUkHma2FK+z2Yfy0W/NhupbLcWEn1RyuUBTQwssm9wRPDE/LoSUA3pmmqPDl87d9tGFDK/ylQTuaql5tF02ljz8wYQiSRf5nzxqTmtnMCmvhyax75n50to/Tn4lh/j1iko+wCAWTMCNkb+m4G1msdoUYnEYn/TizW9vK3LhVTW5ZdI+uVyasdBhRLoylwYidUGCahvJfDSGk0xS74hUXb223AmziSKE3TFPxSnZEv3zi8mOkzsMSubjnpJqrnQXoBnNI8s+j0IyZQ29Zmd8CLLqmgkIOVOuacCokXvKDWkUmkByRO6LwA==']}
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



<pre  style="border:0; background:white; overflow-wrap:break-word;">
    b'{"entry":[{"fullUrl":"urn:uuid:17a80a8d-4cf1-4deb-a1fd-2db1130e5f76","resource":{"attester":[{"mode":"legal","party":{"display":"Example Practitioner","reference":"urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"},"time":"2021-10-25T20:16:29-07:00"}],"author":[{"display":"Example Practitioner","reference":"urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"}],"date":"2021-10-25T20:16:29-07:00","encounter":{"display":"Example Encounter","reference":"urn:uuid:5ce5c83a-000f-47d2-941c-039358cc9112"},"id":"17a80a8d-4cf1-4deb-a1fd-2db1130e5f76","resourceType":"Composition","section":[{"entry":[{"reference":"urn:uuid:014a68ec-d691-49e0-b980-91b0d924e570"}],"title":"Active Condition 1"}],"status":"final","subject":{"display":"Example Patient","reference":"urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece"},"text":{"div":"<div xmlns=\\"http://www.w3.org/1999/xhtml\\"><p><b>Generated Narrative</b></p><div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"><p style=\\"margin-bottom: 0px\\">Resource \\"17a80a8d-4cf1-4deb-a1fd-2db1130e5f76\\" </p></div><p><b>status</b>: final</p><p><b>type</b>: Medical records <span style=\\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\\"> (<a href=\\"https://loinc.org/\\">LOINC</a>#11503-0)</span></p><p><b>encounter</b>: <a href=\\"#Encounter_5ce5c83a-000f-47d2-941c-039358cc9112\\">See above (urn:uuid:5ce5c83a-000f-47d2-941c-039358cc9112: Example Encounter)</a></p><p><b>date</b>: 2021-10-25T20:16:29-07:00</p><p><b>author</b>: <a href=\\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\\">See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: Example Practitioner)</a></p><p><b>title</b>: Active Conditions</p><h3>Attesters</h3><table class=\\"grid\\"><tr><td>-</td><td><b>Mode</b></td><td><b>Time</b></td><td><b>Party</b></td></tr><tr><td>*</td><td>legal</td><td>2021-10-25T20:16:29-07:00</td><td><a href=\\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\\">See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: Example Practitioner)</a></td></tr></table></div>","status":"generated"},"title":"Active Conditions","type":{"coding":[{"code":"11503-0","system":"http://loinc.org"}],"text":"Medical records"}}},{"fullUrl":"urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc","resource":{"id":"0820c16d-91de-4dfa-a3a6-f140a516a9bc","meta":{"lastUpdated":"2013-05-05T16:13:03Z"},"name":[{"family":"Hancock","given":["John"]}],"resourceType":"Practitioner","text":{"div":"<div xmlns=\\"http://www.w3.org/1999/xhtml\\"><p><b>Generated Narrative</b></p><div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"><p style=\\"margin-bottom: 0px\\">Resource \\"0820c16d-91de-4dfa-a3a6-f140a516a9bc\\" Updated \\"2013-05-05T16:13:03Z\\" </p></div><p><b>name</b>: John Hancock </p></div>","status":"generated"}}},{"fullUrl":"urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece","resource":{"active":true,"id":"970af6c9-5bbd-4067-b6c1-d9b2c823aece","name":[{"family":"Patient","given":["CDEX Example"],"text":"CDEX Example Patient"}],"resourceType":"Patient","text":{"div":"<div xmlns=\\"http://www.w3.org/1999/xhtml\\"><p><b>Generated Narrative</b></p><div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"><p style=\\"margin-bottom: 0px\\">Resource \\"970af6c9-5bbd-4067-b6c1-d9b2c823aece\\" </p></div><p><b>active</b>: true</p><p><b>name</b>: CDEX Example Patient</p></div>","status":"generated"}}},{"fullUrl":"urn:uuid:014a68ec-d691-49e0-b980-91b0d924e570","resource":{"asserter":{"reference":"urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"},"category":[{"coding":[{"code":"55607006","display":"Problem","system":"http://snomed.info/sct"},{"code":"75326-9","display":"Problem","system":"http://loinc.org"}]}],"clinicalStatus":{"coding":[{"code":"active","system":"http://terminology.hl7.org/CodeSystem/condition-clinical"}]},"code":{"coding":[{"code":"44054006","display":"Type 2 Diabetes Mellitus","system":"http://snomed.info/sct"}]},"id":"014a68ec-d691-49e0-b980-91b0d924e570","identifier":[{"system":"urn:oid:1.3.6.1.4.1.22812.4.111.0.4.1.2.1","value":"1"}],"onsetDateTime":"2006","resourceType":"Condition","subject":{"reference":"urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece"},"text":{"div":"<div xmlns=\\"http://www.w3.org/1999/xhtml\\"><p><b>Generated Narrative</b></p><div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"><p style=\\"margin-bottom: 0px\\">Resource \\"014a68ec-d691-49e0-b980-91b0d924e570\\" </p></div><p><b>identifier</b>: id: 1</p><p><b>clinicalStatus</b>: Active <span style=\\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\\"> (<a href=\\"http://terminology.hl7.org/3.0.0/CodeSystem-condition-clinical.html\\">Condition Clinical Status Codes</a>#active)</span></p><p><b>category</b>: Problem <span style=\\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\\"> (<a href=\\"https://browser.ihtsdotools.org/\\">SNOMED CT</a>#55607006; <a href=\\"https://loinc.org/\\">LOINC</a>#75326-9)</span></p><p><b>code</b>: Type 2 Diabetes Mellitus <span style=\\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\\"> (<a href=\\"https://browser.ihtsdotools.org/\\">SNOMED CT</a>#44054006)</span></p><p><b>subject</b>: <a href=\\"#Patient_970af6c9-5bbd-4067-b6c1-d9b2c823aece\\">See above (urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece)</a></p><p><b>onset</b>: 2006-01-01</p><p><b>asserter</b>: <a href=\\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\\">See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc)</a></p></div>","status":"generated"}}},{"fullUrl":"urn:uuid:5ce5c83a-000f-47d2-941c-039358cc9112","resource":{"class":{"code":"EMER","system":"http://terminology.hl7.org/CodeSystem/v3-ActCode"},"id":"5ce5c83a-000f-47d2-941c-039358cc9112","participant":[{"individual":{"display":"John Hancock","reference":"urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"}}],"period":{"end":"2021-10-25T20:16:29-07:00","start":"2021-10-25T20:10:29-07:00"},"resourceType":"Encounter","serviceProvider":{"display":"CDEX Example Organization","reference":"urn:uuid:e37f004b-dc10-422b-b833-cdaa10a055a3"},"status":"finished","subject":{"display":"CDEX Example Patient","reference":"urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece"},"text":{"div":"<div xmlns=\\"http://www.w3.org/1999/xhtml\\"><p><b>Generated Narrative</b></p><div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"><p style=\\"margin-bottom: 0px\\">Resource \\"5ce5c83a-000f-47d2-941c-039358cc9112\\" </p></div><p><b>status</b>: finished</p><p><b>class</b>: emergency (Details: http://terminology.hl7.org/CodeSystem/v3-ActCode code EMER = \'emergency\', stated as \'null\')</p><p><b>type</b>: Unknown (qualifier value) <span style=\\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\\"> (<a href=\\"https://browser.ihtsdotools.org/\\">SNOMED CT</a>#261665006)</span></p><p><b>subject</b>: <a href=\\"#Patient_970af6c9-5bbd-4067-b6c1-d9b2c823aece\\">See above (urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece: CDEX Example Patient)</a></p><h3>Participants</h3><table class=\\"grid\\"><tr><td>-</td><td><b>Individual</b></td></tr><tr><td>*</td><td><a href=\\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\\">See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: John Hancock)</a></td></tr></table><p><b>period</b>: 2021-10-25T20:10:29-07:00 --&gt; 2021-10-25T20:16:29-07:00</p><p><b>serviceProvider</b>: <a href=\\"#Organization_e37f004b-dc10-422b-b833-cdaa10a055a3\\">See above (urn:uuid:e37f004b-dc10-422b-b833-cdaa10a055a3: CDEX Example Organization)</a></p></div>","status":"generated"},"type":[{"coding":[{"code":"261665006","display":"Unknown (qualifier value)","system":"http://snomed.info/sct"}],"text":"Unknown (qualifier value)"}]}},{"fullUrl":"urn:uuid:e37f004b-dc10-422b-b833-cdaa10a055a3","resource":{"active":true,"address":[{"city":"Boston","country":"USA","line":["1 CDEX Lane"],"postalCode":"01002","state":"MA"}],"id":"e37f004b-dc10-422b-b833-cdaa10a055a3","name":"CDEX Example Organization","resourceType":"Organization","telecom":[{"system":"phone","value":"(+1) 555-555-5555"},{"system":"email","value":"customer-service@example.org"}],"text":{"div":"<div xmlns=\\"http://www.w3.org/1999/xhtml\\"><p><b>Generated Narrative</b></p><div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"><p style=\\"margin-bottom: 0px\\">Resource \\"e37f004b-dc10-422b-b833-cdaa10a055a3\\" </p></div><p><b>active</b>: true</p><p><b>name</b>: CDEX Example Organization</p><p><b>telecom</b>: ph: (+1) 555-555-5555, <a href=\\"mailto:customer-service@example.org\\">customer-service@example.org</a></p><p><b>address</b>: 1 CDEX Lane Boston MA 01002 USA </p></div>","status":"generated"}}}],"identifier":{"system":"urn:ietf:rfc:3986","value":"urn:uuid:c173535e-135e-48e3-ab64-38bacc68dba8"},"resourceType":"Bundle","timestamp":"2021-10-25T20:16:29-07:00","type":"document"}'
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


<pre  style="border:0; background:white; overflow-wrap:break-word;">
    header:
    eyJhbGciOiJSUzI1NiIsImtpZCI6ImU2ZWZkYjM1MGI2OWIzNjlhNDNhZTYwMTU0ZTE3ZjM5YWM3NWViNTgiLCJrdHkiOiJSUyIsInNpZ1QiOiIyMDIwLTEwLTIzVDA0OjU0OjU2LjA0OCswMDowMCIsInNyQ21zIjpbeyJjb21tSWQiOnsiZGVzYyI6IlZlcmlmaWNhdGlvbiBTaWduYXR1cmUiLCJpZCI6InVybjpvaWQ6MS4yLjg0MC4xMDA2NS4xLjEyLjEuNSJ9LCJjb21tUXVhbHMiOlsiVmVyaWZpY2F0aW9uIG9mIG1lZGljYWwgcmVjb3JkIGludGVncml0eSJdfV0sInR5cCI6IkpXVCIsIng1YyI6WyJNSUlGZVRDQ0ErR2dBd0lCQWdJVU9jRnFMT0JtdDdWUjZ5NEZHbjAwUVNGTVhKZ3dEUVlKS29aSWh2Y05BUUVMQlFBd2dhWXhDekFKQmdOVkJBWVRBbFZUTVJZd0ZBWURWUVFJREExTllYTnpZV05vZFhObGRIUnpNUTh3RFFZRFZRUUhEQVpDYjNOMGIyNHhIVEFiQmdOVkJBb01GRVY0WVcxd2JHVWdUM0puWVc1cGVtRjBhVzl1TVNJd0lBWURWUVFEREJsRFJFVllJRVY0WVcxd2JHVWdUM0puWVc1cGVtRjBhVzl1TVNzd0tRWUpLb1pJaHZjTkFRa0JGaHhqZFhOMGIyMWxjaTF6WlhKMmFXTmxRR1Y0WVcxd2JHVXViM0puTUI0WERUSTFNRGN5TkRFNE1UUTBNRm9YRFRJMk1EY3hPVEU0TVRRME1Gb3dnYVl4Q3pBSkJnTlZCQVlUQWxWVE1SWXdGQVlEVlFRSURBMU5ZWE56WVdOb2RYTmxkSFJ6TVE4d0RRWURWUVFIREFaQ2IzTjBiMjR4SFRBYkJnTlZCQW9NRkVWNFlXMXdiR1VnVDNKbllXNXBlbUYwYVc5dU1TSXdJQVlEVlFRRERCbERSRVZZSUVWNFlXMXdiR1VnVDNKbllXNXBlbUYwYVc5dU1Tc3dLUVlKS29aSWh2Y05BUWtCRmh4amRYTjBiMjFsY2kxelpYSjJhV05sUUdWNFlXMXdiR1V1YjNKbk1JSUJvakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBWThBTUlJQmlnS0NBWUVBcnR5SEllRW1tMU1pMmlSN2xSVzlOUHhBeVM5Qmg4UHhFMWJGS1BiUm8xQldkRllvc0RBRE1jeGRoOWp1eWNzaWhGRW0vdDluY0JlQmVMSTFVdXpFYi9LK0ZXMWFKbmZrK2FaekEyMXBnMXowclJqN2lTaHBLdzhmMGFpaHphVGlhQk9sU3Njb1lEV2VCeTdwZTVRL2VMN1ZSdXFnbFpoVms3WkxTcHc4eGJWVG9GUFl5MkloNTZ3bWQ0eCt3NEk5RFNDc21pRUUxd3RXdVp0ZVZsZ2VjZk1zWS9Yem96SEJUa2s0RnJoOFB4ai8za3ZZVFlVNTJqc2N6QUlMRGxwVUs0Z2E3WEdNbzIzUW91WGRGWFdJOEtNNlhmT1JXQ3FXVSsyVjRCOU1uampHOGpyTytPQ0RIUUhKcUJ4cmtNWVcrR2tiaEJxOFlPbmdRUUgvdFo4Q2o4dmYwWlhFUW91MExXbW9WTmZaWXVxQ0dESjVJZzBsQURtbStsQnd0U2VNOVBwanEwZlZYNC91KytvbzM2TFlpbndOb0JBbTNyUWxCTkk1TVV3Vk9ycnZPaGlXZFl2WVNqM2Z3Q2tiMWFLQm9mRnFQTXIzL25TKzNWT0xnR3A3djdhdENUZldHN2Z4ZjVFOHZoMjd5MWpxM0ZQS1BZMDByTndzNlYzUVp1TlhBZ01CQUFHamdad3dnWmt3Q1FZRFZSMFRCQUl3QURBTEJnTlZIUThFQkFNQ0JlQXdZQVlEVlIwUkJGa3dWNElQZDNkM0xtVjRZVzF3YkdVdWIzSm5vQmtHQ1dDR1NBR0crVnNFQnFBTURBb3hNak0wTlRZM09Ea3poaWxvZEhSd2N6b3ZMMlY0WVcxd2JHVXViM0puTDJab2FYSXZUM0puWVc1cGVtRjBhVzl1THpFeU16QWRCZ05WSFE0RUZnUVU1dS9iTlF0cHMybWtPdVlCVk9GL09heDE2MWd3RFFZSktvWklodmNOQVFFTEJRQURnZ0dCQUJpTE9VMzlORXlTelpTR3oyYU5oYk16VVY1UmFUd3JwRHhEdllqRFgzakVQL2pzbWo0L3BOK0w1UllCWHNCZll4U1V1YlFMZVZ2a2Y1ZnYrb0dybWVDVytmWDh5RTFybCtxODFDQ0wrUThMT096QVpGdUVlWUU5aWVjelk3Zk8xOE1wRjhuQzE0Q0RRYjZETjEwUWFBdGJoVEZha1plT3FaYVVnVG9EZklOc243anphL2JwdDFLZXU1dlVzdTFxRmdqQXB6QTYrTWFsSU5Va0htYTJGSyt6MllmeTBXL05odXBiTGNXRW4xUnl1VUJUUXdzc205d1JQREUvTG9TVUEzcG1tcVBEbDg3ZDl0R0ZESy95bFFUdWFxbDV0RjAybGp6OHdZUWlTUmY1bnp4cVRtdG5NQ212aHlheDc1bjUwdG8vVG40bGgvajFpa28rd0NBV1RNQ05rYittNEcxbXNkb1VZbkVZbi9UaXpXOXZLM0xoVlRXNVpkSSt1Vnlhc2RCaFJMb3lsd1lpZFVHQ2FodkpmRFNHazB4Uzc0aFVYYjIyM0FtemlTS0UzVEZQeFNuWkV2M3ppOG1Pa3pzTVN1YmpucEpxcm5RWG9Cbk5JOHMrajBJeVpRMjlabWQ4Q0xMcW1na0lPVk91YWNDb2tYdktEV2tVbWtCeVJPNkx3QT09Il19
    
    payload:
    eyJlbnRyeSI6W3siZnVsbFVybCI6InVybjp1dWlkOjE3YTgwYThkLTRjZjEtNGRlYi1hMWZkLTJkYjExMzBlNWY3NiIsInJlc291cmNlIjp7ImF0dGVzdGVyIjpbeyJtb2RlIjoibGVnYWwiLCJwYXJ0eSI6eyJkaXNwbGF5IjoiRXhhbXBsZSBQcmFjdGl0aW9uZXIiLCJyZWZlcmVuY2UiOiJ1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMifSwidGltZSI6IjIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDAifV0sImF1dGhvciI6W3siZGlzcGxheSI6IkV4YW1wbGUgUHJhY3RpdGlvbmVyIiwicmVmZXJlbmNlIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIn1dLCJkYXRlIjoiMjAyMS0xMC0yNVQyMDoxNjoyOS0wNzowMCIsImVuY291bnRlciI6eyJkaXNwbGF5IjoiRXhhbXBsZSBFbmNvdW50ZXIiLCJyZWZlcmVuY2UiOiJ1cm46dXVpZDo1Y2U1YzgzYS0wMDBmLTQ3ZDItOTQxYy0wMzkzNThjYzkxMTIifSwiaWQiOiIxN2E4MGE4ZC00Y2YxLTRkZWItYTFmZC0yZGIxMTMwZTVmNzYiLCJyZXNvdXJjZVR5cGUiOiJDb21wb3NpdGlvbiIsInNlY3Rpb24iOlt7ImVudHJ5IjpbeyJyZWZlcmVuY2UiOiJ1cm46dXVpZDowMTRhNjhlYy1kNjkxLTQ5ZTAtYjk4MC05MWIwZDkyNGU1NzAifV0sInRpdGxlIjoiQWN0aXZlIENvbmRpdGlvbiAxIn1dLCJzdGF0dXMiOiJmaW5hbCIsInN1YmplY3QiOnsiZGlzcGxheSI6IkV4YW1wbGUgUGF0aWVudCIsInJlZmVyZW5jZSI6InVybjp1dWlkOjk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZSJ9LCJ0ZXh0Ijp7ImRpdiI6IjxkaXYgeG1sbnM9XCJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hodG1sXCI-PHA-PGI-R2VuZXJhdGVkIE5hcnJhdGl2ZTwvYj48L3A-PGRpdiBzdHlsZT1cImRpc3BsYXk6IGlubGluZS1ibG9jazsgYmFja2dyb3VuZC1jb2xvcjogI2Q5ZTBlNzsgcGFkZGluZzogNnB4OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQgIzhkYTFiNDsgYm9yZGVyLXJhZGl1czogNXB4OyBsaW5lLWhlaWdodDogNjAlXCI-PHAgc3R5bGU9XCJtYXJnaW4tYm90dG9tOiAwcHhcIj5SZXNvdXJjZSBcIjE3YTgwYThkLTRjZjEtNGRlYi1hMWZkLTJkYjExMzBlNWY3NlwiIDwvcD48L2Rpdj48cD48Yj5zdGF0dXM8L2I-OiBmaW5hbDwvcD48cD48Yj50eXBlPC9iPjogTWVkaWNhbCByZWNvcmRzIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vbG9pbmMub3JnL1wiPkxPSU5DPC9hPiMxMTUwMy0wKTwvc3Bhbj48L3A-PHA-PGI-ZW5jb3VudGVyPC9iPjogPGEgaHJlZj1cIiNFbmNvdW50ZXJfNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyXCI-U2VlIGFib3ZlICh1cm46dXVpZDo1Y2U1YzgzYS0wMDBmLTQ3ZDItOTQxYy0wMzkzNThjYzkxMTI6IEV4YW1wbGUgRW5jb3VudGVyKTwvYT48L3A-PHA-PGI-ZGF0ZTwvYj46IDIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDA8L3A-PHA-PGI-YXV0aG9yPC9iPjogPGEgaHJlZj1cIiNQcmFjdGl0aW9uZXJfMDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjXCI-U2VlIGFib3ZlICh1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmM6IEV4YW1wbGUgUHJhY3RpdGlvbmVyKTwvYT48L3A-PHA-PGI-dGl0bGU8L2I-OiBBY3RpdmUgQ29uZGl0aW9uczwvcD48aDM-QXR0ZXN0ZXJzPC9oMz48dGFibGUgY2xhc3M9XCJncmlkXCI-PHRyPjx0ZD4tPC90ZD48dGQ-PGI-TW9kZTwvYj48L3RkPjx0ZD48Yj5UaW1lPC9iPjwvdGQ-PHRkPjxiPlBhcnR5PC9iPjwvdGQ-PC90cj48dHI-PHRkPio8L3RkPjx0ZD5sZWdhbDwvdGQ-PHRkPjIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDA8L3RkPjx0ZD48YSBocmVmPVwiI1ByYWN0aXRpb25lcl8wODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmNcIj5TZWUgYWJvdmUgKHVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYzogRXhhbXBsZSBQcmFjdGl0aW9uZXIpPC9hPjwvdGQ-PC90cj48L3RhYmxlPjwvZGl2PiIsInN0YXR1cyI6ImdlbmVyYXRlZCJ9LCJ0aXRsZSI6IkFjdGl2ZSBDb25kaXRpb25zIiwidHlwZSI6eyJjb2RpbmciOlt7ImNvZGUiOiIxMTUwMy0wIiwic3lzdGVtIjoiaHR0cDovL2xvaW5jLm9yZyJ9XSwidGV4dCI6Ik1lZGljYWwgcmVjb3JkcyJ9fX0seyJmdWxsVXJsIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIiwicmVzb3VyY2UiOnsiaWQiOiIwODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMiLCJtZXRhIjp7Imxhc3RVcGRhdGVkIjoiMjAxMy0wNS0wNVQxNjoxMzowM1oifSwibmFtZSI6W3siZmFtaWx5IjoiSGFuY29jayIsImdpdmVuIjpbIkpvaG4iXX1dLCJyZXNvdXJjZVR5cGUiOiJQcmFjdGl0aW9uZXIiLCJ0ZXh0Ijp7ImRpdiI6IjxkaXYgeG1sbnM9XCJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hodG1sXCI-PHA-PGI-R2VuZXJhdGVkIE5hcnJhdGl2ZTwvYj48L3A-PGRpdiBzdHlsZT1cImRpc3BsYXk6IGlubGluZS1ibG9jazsgYmFja2dyb3VuZC1jb2xvcjogI2Q5ZTBlNzsgcGFkZGluZzogNnB4OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQgIzhkYTFiNDsgYm9yZGVyLXJhZGl1czogNXB4OyBsaW5lLWhlaWdodDogNjAlXCI-PHAgc3R5bGU9XCJtYXJnaW4tYm90dG9tOiAwcHhcIj5SZXNvdXJjZSBcIjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliY1wiIFVwZGF0ZWQgXCIyMDEzLTA1LTA1VDE2OjEzOjAzWlwiIDwvcD48L2Rpdj48cD48Yj5uYW1lPC9iPjogSm9obiBIYW5jb2NrIDwvcD48L2Rpdj4iLCJzdGF0dXMiOiJnZW5lcmF0ZWQifX19LHsiZnVsbFVybCI6InVybjp1dWlkOjk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZSIsInJlc291cmNlIjp7ImFjdGl2ZSI6dHJ1ZSwiaWQiOiI5NzBhZjZjOS01YmJkLTQwNjctYjZjMS1kOWIyYzgyM2FlY2UiLCJuYW1lIjpbeyJmYW1pbHkiOiJQYXRpZW50IiwiZ2l2ZW4iOlsiQ0RFWCBFeGFtcGxlIl0sInRleHQiOiJDREVYIEV4YW1wbGUgUGF0aWVudCJ9XSwicmVzb3VyY2VUeXBlIjoiUGF0aWVudCIsInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiOTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlXCIgPC9wPjwvZGl2PjxwPjxiPmFjdGl2ZTwvYj46IHRydWU8L3A-PHA-PGI-bmFtZTwvYj46IENERVggRXhhbXBsZSBQYXRpZW50PC9wPjwvZGl2PiIsInN0YXR1cyI6ImdlbmVyYXRlZCJ9fX0seyJmdWxsVXJsIjoidXJuOnV1aWQ6MDE0YTY4ZWMtZDY5MS00OWUwLWI5ODAtOTFiMGQ5MjRlNTcwIiwicmVzb3VyY2UiOnsiYXNzZXJ0ZXIiOnsicmVmZXJlbmNlIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIn0sImNhdGVnb3J5IjpbeyJjb2RpbmciOlt7ImNvZGUiOiI1NTYwNzAwNiIsImRpc3BsYXkiOiJQcm9ibGVtIiwic3lzdGVtIjoiaHR0cDovL3Nub21lZC5pbmZvL3NjdCJ9LHsiY29kZSI6Ijc1MzI2LTkiLCJkaXNwbGF5IjoiUHJvYmxlbSIsInN5c3RlbSI6Imh0dHA6Ly9sb2luYy5vcmcifV19XSwiY2xpbmljYWxTdGF0dXMiOnsiY29kaW5nIjpbeyJjb2RlIjoiYWN0aXZlIiwic3lzdGVtIjoiaHR0cDovL3Rlcm1pbm9sb2d5LmhsNy5vcmcvQ29kZVN5c3RlbS9jb25kaXRpb24tY2xpbmljYWwifV19LCJjb2RlIjp7ImNvZGluZyI6W3siY29kZSI6IjQ0MDU0MDA2IiwiZGlzcGxheSI6IlR5cGUgMiBEaWFiZXRlcyBNZWxsaXR1cyIsInN5c3RlbSI6Imh0dHA6Ly9zbm9tZWQuaW5mby9zY3QifV19LCJpZCI6IjAxNGE2OGVjLWQ2OTEtNDllMC1iOTgwLTkxYjBkOTI0ZTU3MCIsImlkZW50aWZpZXIiOlt7InN5c3RlbSI6InVybjpvaWQ6MS4zLjYuMS40LjEuMjI4MTIuNC4xMTEuMC40LjEuMi4xIiwidmFsdWUiOiIxIn1dLCJvbnNldERhdGVUaW1lIjoiMjAwNiIsInJlc291cmNlVHlwZSI6IkNvbmRpdGlvbiIsInN1YmplY3QiOnsicmVmZXJlbmNlIjoidXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlIn0sInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiMDE0YTY4ZWMtZDY5MS00OWUwLWI5ODAtOTFiMGQ5MjRlNTcwXCIgPC9wPjwvZGl2PjxwPjxiPmlkZW50aWZpZXI8L2I-OiBpZDogMTwvcD48cD48Yj5jbGluaWNhbFN0YXR1czwvYj46IEFjdGl2ZSA8c3BhbiBzdHlsZT1cImJhY2tncm91bmQ6IExpZ2h0R29sZGVuUm9kWWVsbG93OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQga2hha2lcIj4gKDxhIGhyZWY9XCJodHRwOi8vdGVybWlub2xvZ3kuaGw3Lm9yZy8zLjAuMC9Db2RlU3lzdGVtLWNvbmRpdGlvbi1jbGluaWNhbC5odG1sXCI-Q29uZGl0aW9uIENsaW5pY2FsIFN0YXR1cyBDb2RlczwvYT4jYWN0aXZlKTwvc3Bhbj48L3A-PHA-PGI-Y2F0ZWdvcnk8L2I-OiBQcm9ibGVtIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vYnJvd3Nlci5paHRzZG90b29scy5vcmcvXCI-U05PTUVEIENUPC9hPiM1NTYwNzAwNjsgPGEgaHJlZj1cImh0dHBzOi8vbG9pbmMub3JnL1wiPkxPSU5DPC9hPiM3NTMyNi05KTwvc3Bhbj48L3A-PHA-PGI-Y29kZTwvYj46IFR5cGUgMiBEaWFiZXRlcyBNZWxsaXR1cyA8c3BhbiBzdHlsZT1cImJhY2tncm91bmQ6IExpZ2h0R29sZGVuUm9kWWVsbG93OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQga2hha2lcIj4gKDxhIGhyZWY9XCJodHRwczovL2Jyb3dzZXIuaWh0c2RvdG9vbHMub3JnL1wiPlNOT01FRCBDVDwvYT4jNDQwNTQwMDYpPC9zcGFuPjwvcD48cD48Yj5zdWJqZWN0PC9iPjogPGEgaHJlZj1cIiNQYXRpZW50Xzk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZVwiPlNlZSBhYm92ZSAodXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlKTwvYT48L3A-PHA-PGI-b25zZXQ8L2I-OiAyMDA2LTAxLTAxPC9wPjxwPjxiPmFzc2VydGVyPC9iPjogPGEgaHJlZj1cIiNQcmFjdGl0aW9uZXJfMDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjXCI-U2VlIGFib3ZlICh1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMpPC9hPjwvcD48L2Rpdj4iLCJzdGF0dXMiOiJnZW5lcmF0ZWQifX19LHsiZnVsbFVybCI6InVybjp1dWlkOjVjZTVjODNhLTAwMGYtNDdkMi05NDFjLTAzOTM1OGNjOTExMiIsInJlc291cmNlIjp7ImNsYXNzIjp7ImNvZGUiOiJFTUVSIiwic3lzdGVtIjoiaHR0cDovL3Rlcm1pbm9sb2d5LmhsNy5vcmcvQ29kZVN5c3RlbS92My1BY3RDb2RlIn0sImlkIjoiNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyIiwicGFydGljaXBhbnQiOlt7ImluZGl2aWR1YWwiOnsiZGlzcGxheSI6IkpvaG4gSGFuY29jayIsInJlZmVyZW5jZSI6InVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYyJ9fV0sInBlcmlvZCI6eyJlbmQiOiIyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwIiwic3RhcnQiOiIyMDIxLTEwLTI1VDIwOjEwOjI5LTA3OjAwIn0sInJlc291cmNlVHlwZSI6IkVuY291bnRlciIsInNlcnZpY2VQcm92aWRlciI6eyJkaXNwbGF5IjoiQ0RFWCBFeGFtcGxlIE9yZ2FuaXphdGlvbiIsInJlZmVyZW5jZSI6InVybjp1dWlkOmUzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhMyJ9LCJzdGF0dXMiOiJmaW5pc2hlZCIsInN1YmplY3QiOnsiZGlzcGxheSI6IkNERVggRXhhbXBsZSBQYXRpZW50IiwicmVmZXJlbmNlIjoidXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlIn0sInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyXCIgPC9wPjwvZGl2PjxwPjxiPnN0YXR1czwvYj46IGZpbmlzaGVkPC9wPjxwPjxiPmNsYXNzPC9iPjogZW1lcmdlbmN5IChEZXRhaWxzOiBodHRwOi8vdGVybWlub2xvZ3kuaGw3Lm9yZy9Db2RlU3lzdGVtL3YzLUFjdENvZGUgY29kZSBFTUVSID0gJ2VtZXJnZW5jeScsIHN0YXRlZCBhcyAnbnVsbCcpPC9wPjxwPjxiPnR5cGU8L2I-OiBVbmtub3duIChxdWFsaWZpZXIgdmFsdWUpIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vYnJvd3Nlci5paHRzZG90b29scy5vcmcvXCI-U05PTUVEIENUPC9hPiMyNjE2NjUwMDYpPC9zcGFuPjwvcD48cD48Yj5zdWJqZWN0PC9iPjogPGEgaHJlZj1cIiNQYXRpZW50Xzk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZVwiPlNlZSBhYm92ZSAodXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlOiBDREVYIEV4YW1wbGUgUGF0aWVudCk8L2E-PC9wPjxoMz5QYXJ0aWNpcGFudHM8L2gzPjx0YWJsZSBjbGFzcz1cImdyaWRcIj48dHI-PHRkPi08L3RkPjx0ZD48Yj5JbmRpdmlkdWFsPC9iPjwvdGQ-PC90cj48dHI-PHRkPio8L3RkPjx0ZD48YSBocmVmPVwiI1ByYWN0aXRpb25lcl8wODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmNcIj5TZWUgYWJvdmUgKHVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYzogSm9obiBIYW5jb2NrKTwvYT48L3RkPjwvdHI-PC90YWJsZT48cD48Yj5wZXJpb2Q8L2I-OiAyMDIxLTEwLTI1VDIwOjEwOjI5LTA3OjAwIC0tJmd0OyAyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwPC9wPjxwPjxiPnNlcnZpY2VQcm92aWRlcjwvYj46IDxhIGhyZWY9XCIjT3JnYW5pemF0aW9uX2UzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhM1wiPlNlZSBhYm92ZSAodXJuOnV1aWQ6ZTM3ZjAwNGItZGMxMC00MjJiLWI4MzMtY2RhYTEwYTA1NWEzOiBDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uKTwvYT48L3A-PC9kaXY-Iiwic3RhdHVzIjoiZ2VuZXJhdGVkIn0sInR5cGUiOlt7ImNvZGluZyI6W3siY29kZSI6IjI2MTY2NTAwNiIsImRpc3BsYXkiOiJVbmtub3duIChxdWFsaWZpZXIgdmFsdWUpIiwic3lzdGVtIjoiaHR0cDovL3Nub21lZC5pbmZvL3NjdCJ9XSwidGV4dCI6IlVua25vd24gKHF1YWxpZmllciB2YWx1ZSkifV19fSx7ImZ1bGxVcmwiOiJ1cm46dXVpZDplMzdmMDA0Yi1kYzEwLTQyMmItYjgzMy1jZGFhMTBhMDU1YTMiLCJyZXNvdXJjZSI6eyJhY3RpdmUiOnRydWUsImFkZHJlc3MiOlt7ImNpdHkiOiJCb3N0b24iLCJjb3VudHJ5IjoiVVNBIiwibGluZSI6WyIxIENERVggTGFuZSJdLCJwb3N0YWxDb2RlIjoiMDEwMDIiLCJzdGF0ZSI6Ik1BIn1dLCJpZCI6ImUzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhMyIsIm5hbWUiOiJDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uIiwicmVzb3VyY2VUeXBlIjoiT3JnYW5pemF0aW9uIiwidGVsZWNvbSI6W3sic3lzdGVtIjoicGhvbmUiLCJ2YWx1ZSI6IigrMSkgNTU1LTU1NS01NTU1In0seyJzeXN0ZW0iOiJlbWFpbCIsInZhbHVlIjoiY3VzdG9tZXItc2VydmljZUBleGFtcGxlLm9yZyJ9XSwidGV4dCI6eyJkaXYiOiI8ZGl2IHhtbG5zPVwiaHR0cDovL3d3dy53My5vcmcvMTk5OS94aHRtbFwiPjxwPjxiPkdlbmVyYXRlZCBOYXJyYXRpdmU8L2I-PC9wPjxkaXYgc3R5bGU9XCJkaXNwbGF5OiBpbmxpbmUtYmxvY2s7IGJhY2tncm91bmQtY29sb3I6ICNkOWUwZTc7IHBhZGRpbmc6IDZweDsgbWFyZ2luOiA0cHg7IGJvcmRlcjogMXB4IHNvbGlkICM4ZGExYjQ7IGJvcmRlci1yYWRpdXM6IDVweDsgbGluZS1oZWlnaHQ6IDYwJVwiPjxwIHN0eWxlPVwibWFyZ2luLWJvdHRvbTogMHB4XCI-UmVzb3VyY2UgXCJlMzdmMDA0Yi1kYzEwLTQyMmItYjgzMy1jZGFhMTBhMDU1YTNcIiA8L3A-PC9kaXY-PHA-PGI-YWN0aXZlPC9iPjogdHJ1ZTwvcD48cD48Yj5uYW1lPC9iPjogQ0RFWCBFeGFtcGxlIE9yZ2FuaXphdGlvbjwvcD48cD48Yj50ZWxlY29tPC9iPjogcGg6ICgrMSkgNTU1LTU1NS01NTU1LCA8YSBocmVmPVwibWFpbHRvOmN1c3RvbWVyLXNlcnZpY2VAZXhhbXBsZS5vcmdcIj5jdXN0b21lci1zZXJ2aWNlQGV4YW1wbGUub3JnPC9hPjwvcD48cD48Yj5hZGRyZXNzPC9iPjogMSBDREVYIExhbmUgQm9zdG9uIE1BIDAxMDAyIFVTQSA8L3A-PC9kaXY-Iiwic3RhdHVzIjoiZ2VuZXJhdGVkIn19fV0sImlkZW50aWZpZXIiOnsic3lzdGVtIjoidXJuOmlldGY6cmZjOjM5ODYiLCJ2YWx1ZSI6InVybjp1dWlkOmMxNzM1MzVlLTEzNWUtNDhlMy1hYjY0LTM4YmFjYzY4ZGJhOCJ9LCJyZXNvdXJjZVR5cGUiOiJCdW5kbGUiLCJ0aW1lc3RhbXAiOiIyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwIiwidHlwZSI6ImRvY3VtZW50In0
    
    signature:
    cHbVVVD8FN5e9iVCWGQCOy9BlpWKZRgw-xGuZ1N3J_v3uRNl-CsgZb4ILpqdnWsk-l0rZQsfLB64CkogBolhn6-Z_Yk9uwFABhsGJV296wlSNRl5nbawIPeutns_bY1TK9JLPWTXObOIGPHWGDgEAlvMuYbuJtzMxeEFebSyPr_ejovpxbmGVxxo5dp2u6nzICsuCjB594w43i5Ylk1fCMq3qVgmTQuda-fEWFeiTaY-olg6vvf7hokofGEhwNaPP8acX8S6bKw8Mg8uNKvREM4C2XTidhsn1V25adSLJX6Va0p4J_9MlhTlSaOug58UrQSbkU0gK-PD0SMqGBQZKlum2dgorXefH65vA-DBeKLQP9-Ao8KqE4Hn_y2-luQunJ-1TPLZ60ch6KKk548RBRY4uBStaHpZJhb3Ez9A6s_A4ap1tXOe_wRspY-fnYbcytkaSN945gCG48bHywl4cRpq_qv0MdOWwQeUXCtWTp7Sh56Y-4x4nmhKZTTdxZ0H
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
<pre  style="border:0; background:white; overflow-wrap:break-word;">
    header:
    eyJhbGciOiJSUzI1NiIsImtpZCI6ImU2ZWZkYjM1MGI2OWIzNjlhNDNhZTYwMTU0ZTE3ZjM5YWM3NWViNTgiLCJrdHkiOiJSUyIsInNpZ1QiOiIyMDIwLTEwLTIzVDA0OjU0OjU2LjA0OCswMDowMCIsInNyQ21zIjpbeyJjb21tSWQiOnsiZGVzYyI6IlZlcmlmaWNhdGlvbiBTaWduYXR1cmUiLCJpZCI6InVybjpvaWQ6MS4yLjg0MC4xMDA2NS4xLjEyLjEuNSJ9LCJjb21tUXVhbHMiOlsiVmVyaWZpY2F0aW9uIG9mIG1lZGljYWwgcmVjb3JkIGludGVncml0eSJdfV0sInR5cCI6IkpXVCIsIng1YyI6WyJNSUlGZVRDQ0ErR2dBd0lCQWdJVU9jRnFMT0JtdDdWUjZ5NEZHbjAwUVNGTVhKZ3dEUVlKS29aSWh2Y05BUUVMQlFBd2dhWXhDekFKQmdOVkJBWVRBbFZUTVJZd0ZBWURWUVFJREExTllYTnpZV05vZFhObGRIUnpNUTh3RFFZRFZRUUhEQVpDYjNOMGIyNHhIVEFiQmdOVkJBb01GRVY0WVcxd2JHVWdUM0puWVc1cGVtRjBhVzl1TVNJd0lBWURWUVFEREJsRFJFVllJRVY0WVcxd2JHVWdUM0puWVc1cGVtRjBhVzl1TVNzd0tRWUpLb1pJaHZjTkFRa0JGaHhqZFhOMGIyMWxjaTF6WlhKMmFXTmxRR1Y0WVcxd2JHVXViM0puTUI0WERUSTFNRGN5TkRFNE1UUTBNRm9YRFRJMk1EY3hPVEU0TVRRME1Gb3dnYVl4Q3pBSkJnTlZCQVlUQWxWVE1SWXdGQVlEVlFRSURBMU5ZWE56WVdOb2RYTmxkSFJ6TVE4d0RRWURWUVFIREFaQ2IzTjBiMjR4SFRBYkJnTlZCQW9NRkVWNFlXMXdiR1VnVDNKbllXNXBlbUYwYVc5dU1TSXdJQVlEVlFRRERCbERSRVZZSUVWNFlXMXdiR1VnVDNKbllXNXBlbUYwYVc5dU1Tc3dLUVlKS29aSWh2Y05BUWtCRmh4amRYTjBiMjFsY2kxelpYSjJhV05sUUdWNFlXMXdiR1V1YjNKbk1JSUJvakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBWThBTUlJQmlnS0NBWUVBcnR5SEllRW1tMU1pMmlSN2xSVzlOUHhBeVM5Qmg4UHhFMWJGS1BiUm8xQldkRllvc0RBRE1jeGRoOWp1eWNzaWhGRW0vdDluY0JlQmVMSTFVdXpFYi9LK0ZXMWFKbmZrK2FaekEyMXBnMXowclJqN2lTaHBLdzhmMGFpaHphVGlhQk9sU3Njb1lEV2VCeTdwZTVRL2VMN1ZSdXFnbFpoVms3WkxTcHc4eGJWVG9GUFl5MkloNTZ3bWQ0eCt3NEk5RFNDc21pRUUxd3RXdVp0ZVZsZ2VjZk1zWS9Yem96SEJUa2s0RnJoOFB4ai8za3ZZVFlVNTJqc2N6QUlMRGxwVUs0Z2E3WEdNbzIzUW91WGRGWFdJOEtNNlhmT1JXQ3FXVSsyVjRCOU1uampHOGpyTytPQ0RIUUhKcUJ4cmtNWVcrR2tiaEJxOFlPbmdRUUgvdFo4Q2o4dmYwWlhFUW91MExXbW9WTmZaWXVxQ0dESjVJZzBsQURtbStsQnd0U2VNOVBwanEwZlZYNC91KytvbzM2TFlpbndOb0JBbTNyUWxCTkk1TVV3Vk9ycnZPaGlXZFl2WVNqM2Z3Q2tiMWFLQm9mRnFQTXIzL25TKzNWT0xnR3A3djdhdENUZldHN2Z4ZjVFOHZoMjd5MWpxM0ZQS1BZMDByTndzNlYzUVp1TlhBZ01CQUFHamdad3dnWmt3Q1FZRFZSMFRCQUl3QURBTEJnTlZIUThFQkFNQ0JlQXdZQVlEVlIwUkJGa3dWNElQZDNkM0xtVjRZVzF3YkdVdWIzSm5vQmtHQ1dDR1NBR0crVnNFQnFBTURBb3hNak0wTlRZM09Ea3poaWxvZEhSd2N6b3ZMMlY0WVcxd2JHVXViM0puTDJab2FYSXZUM0puWVc1cGVtRjBhVzl1THpFeU16QWRCZ05WSFE0RUZnUVU1dS9iTlF0cHMybWtPdVlCVk9GL09heDE2MWd3RFFZSktvWklodmNOQVFFTEJRQURnZ0dCQUJpTE9VMzlORXlTelpTR3oyYU5oYk16VVY1UmFUd3JwRHhEdllqRFgzakVQL2pzbWo0L3BOK0w1UllCWHNCZll4U1V1YlFMZVZ2a2Y1ZnYrb0dybWVDVytmWDh5RTFybCtxODFDQ0wrUThMT096QVpGdUVlWUU5aWVjelk3Zk8xOE1wRjhuQzE0Q0RRYjZETjEwUWFBdGJoVEZha1plT3FaYVVnVG9EZklOc243anphL2JwdDFLZXU1dlVzdTFxRmdqQXB6QTYrTWFsSU5Va0htYTJGSyt6MllmeTBXL05odXBiTGNXRW4xUnl1VUJUUXdzc205d1JQREUvTG9TVUEzcG1tcVBEbDg3ZDl0R0ZESy95bFFUdWFxbDV0RjAybGp6OHdZUWlTUmY1bnp4cVRtdG5NQ212aHlheDc1bjUwdG8vVG40bGgvajFpa28rd0NBV1RNQ05rYittNEcxbXNkb1VZbkVZbi9UaXpXOXZLM0xoVlRXNVpkSSt1Vnlhc2RCaFJMb3lsd1lpZFVHQ2FodkpmRFNHazB4Uzc0aFVYYjIyM0FtemlTS0UzVEZQeFNuWkV2M3ppOG1Pa3pzTVN1YmpucEpxcm5RWG9Cbk5JOHMrajBJeVpRMjlabWQ4Q0xMcW1na0lPVk91YWNDb2tYdktEV2tVbWtCeVJPNkx3QT09Il19
    
    payload:
    
    
    signature:
    cHbVVVD8FN5e9iVCWGQCOy9BlpWKZRgw-xGuZ1N3J_v3uRNl-CsgZb4ILpqdnWsk-l0rZQsfLB64CkogBolhn6-Z_Yk9uwFABhsGJV296wlSNRl5nbawIPeutns_bY1TK9JLPWTXObOIGPHWGDgEAlvMuYbuJtzMxeEFebSyPr_ejovpxbmGVxxo5dp2u6nzICsuCjB594w43i5Ylk1fCMq3qVgmTQuda-fEWFeiTaY-olg6vvf7hokofGEhwNaPP8acX8S6bKw8Mg8uNKvREM4C2XTidhsn1V25adSLJX6Va0p4J_9MlhTlSaOug58UrQSbkU0gK-PD0SMqGBQZKlum2dgorXefH65vA-DBeKLQP9-Ao8KqE4Hn_y2-luQunJ-1TPLZ60ch6KKk548RBRY4uBStaHpZJhb3Ez9A6s_A4ap1tXOe_wRspY-fnYbcytkaSN945gCG48bHywl4cRpq_qv0MdOWwQeUXCtWTp7Sh56Y-4x4nmhKZTTdxZ0H
    
    
    Signature in compact serialization format:
    ================================================================================
    eyJhbGciOiJSUzI1NiIsImtpZCI6ImU2ZWZkYjM1MGI2OWIzNjlhNDNhZTYwMTU0ZTE3ZjM5YWM3NWViNTgiLCJrdHkiOiJSUyIsInNpZ1QiOiIyMDIwLTEwLTIzVDA0OjU0OjU2LjA0OCswMDowMCIsInNyQ21zIjpbeyJjb21tSWQiOnsiZGVzYyI6IlZlcmlmaWNhdGlvbiBTaWduYXR1cmUiLCJpZCI6InVybjpvaWQ6MS4yLjg0MC4xMDA2NS4xLjEyLjEuNSJ9LCJjb21tUXVhbHMiOlsiVmVyaWZpY2F0aW9uIG9mIG1lZGljYWwgcmVjb3JkIGludGVncml0eSJdfV0sInR5cCI6IkpXVCIsIng1YyI6WyJNSUlGZVRDQ0ErR2dBd0lCQWdJVU9jRnFMT0JtdDdWUjZ5NEZHbjAwUVNGTVhKZ3dEUVlKS29aSWh2Y05BUUVMQlFBd2dhWXhDekFKQmdOVkJBWVRBbFZUTVJZd0ZBWURWUVFJREExTllYTnpZV05vZFhObGRIUnpNUTh3RFFZRFZRUUhEQVpDYjNOMGIyNHhIVEFiQmdOVkJBb01GRVY0WVcxd2JHVWdUM0puWVc1cGVtRjBhVzl1TVNJd0lBWURWUVFEREJsRFJFVllJRVY0WVcxd2JHVWdUM0puWVc1cGVtRjBhVzl1TVNzd0tRWUpLb1pJaHZjTkFRa0JGaHhqZFhOMGIyMWxjaTF6WlhKMmFXTmxRR1Y0WVcxd2JHVXViM0puTUI0WERUSTFNRGN5TkRFNE1UUTBNRm9YRFRJMk1EY3hPVEU0TVRRME1Gb3dnYVl4Q3pBSkJnTlZCQVlUQWxWVE1SWXdGQVlEVlFRSURBMU5ZWE56WVdOb2RYTmxkSFJ6TVE4d0RRWURWUVFIREFaQ2IzTjBiMjR4SFRBYkJnTlZCQW9NRkVWNFlXMXdiR1VnVDNKbllXNXBlbUYwYVc5dU1TSXdJQVlEVlFRRERCbERSRVZZSUVWNFlXMXdiR1VnVDNKbllXNXBlbUYwYVc5dU1Tc3dLUVlKS29aSWh2Y05BUWtCRmh4amRYTjBiMjFsY2kxelpYSjJhV05sUUdWNFlXMXdiR1V1YjNKbk1JSUJvakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBWThBTUlJQmlnS0NBWUVBcnR5SEllRW1tMU1pMmlSN2xSVzlOUHhBeVM5Qmg4UHhFMWJGS1BiUm8xQldkRllvc0RBRE1jeGRoOWp1eWNzaWhGRW0vdDluY0JlQmVMSTFVdXpFYi9LK0ZXMWFKbmZrK2FaekEyMXBnMXowclJqN2lTaHBLdzhmMGFpaHphVGlhQk9sU3Njb1lEV2VCeTdwZTVRL2VMN1ZSdXFnbFpoVms3WkxTcHc4eGJWVG9GUFl5MkloNTZ3bWQ0eCt3NEk5RFNDc21pRUUxd3RXdVp0ZVZsZ2VjZk1zWS9Yem96SEJUa2s0RnJoOFB4ai8za3ZZVFlVNTJqc2N6QUlMRGxwVUs0Z2E3WEdNbzIzUW91WGRGWFdJOEtNNlhmT1JXQ3FXVSsyVjRCOU1uampHOGpyTytPQ0RIUUhKcUJ4cmtNWVcrR2tiaEJxOFlPbmdRUUgvdFo4Q2o4dmYwWlhFUW91MExXbW9WTmZaWXVxQ0dESjVJZzBsQURtbStsQnd0U2VNOVBwanEwZlZYNC91KytvbzM2TFlpbndOb0JBbTNyUWxCTkk1TVV3Vk9ycnZPaGlXZFl2WVNqM2Z3Q2tiMWFLQm9mRnFQTXIzL25TKzNWT0xnR3A3djdhdENUZldHN2Z4ZjVFOHZoMjd5MWpxM0ZQS1BZMDByTndzNlYzUVp1TlhBZ01CQUFHamdad3dnWmt3Q1FZRFZSMFRCQUl3QURBTEJnTlZIUThFQkFNQ0JlQXdZQVlEVlIwUkJGa3dWNElQZDNkM0xtVjRZVzF3YkdVdWIzSm5vQmtHQ1dDR1NBR0crVnNFQnFBTURBb3hNak0wTlRZM09Ea3poaWxvZEhSd2N6b3ZMMlY0WVcxd2JHVXViM0puTDJab2FYSXZUM0puWVc1cGVtRjBhVzl1THpFeU16QWRCZ05WSFE0RUZnUVU1dS9iTlF0cHMybWtPdVlCVk9GL09heDE2MWd3RFFZSktvWklodmNOQVFFTEJRQURnZ0dCQUJpTE9VMzlORXlTelpTR3oyYU5oYk16VVY1UmFUd3JwRHhEdllqRFgzakVQL2pzbWo0L3BOK0w1UllCWHNCZll4U1V1YlFMZVZ2a2Y1ZnYrb0dybWVDVytmWDh5RTFybCtxODFDQ0wrUThMT096QVpGdUVlWUU5aWVjelk3Zk8xOE1wRjhuQzE0Q0RRYjZETjEwUWFBdGJoVEZha1plT3FaYVVnVG9EZklOc243anphL2JwdDFLZXU1dlVzdTFxRmdqQXB6QTYrTWFsSU5Va0htYTJGSyt6MllmeTBXL05odXBiTGNXRW4xUnl1VUJUUXdzc205d1JQREUvTG9TVUEzcG1tcVBEbDg3ZDl0R0ZESy95bFFUdWFxbDV0RjAybGp6OHdZUWlTUmY1bnp4cVRtdG5NQ212aHlheDc1bjUwdG8vVG40bGgvajFpa28rd0NBV1RNQ05rYittNEcxbXNkb1VZbkVZbi9UaXpXOXZLM0xoVlRXNVpkSSt1Vnlhc2RCaFJMb3lsd1lpZFVHQ2FodkpmRFNHazB4Uzc0aFVYYjIyM0FtemlTS0UzVEZQeFNuWkV2M3ppOG1Pa3pzTVN1YmpucEpxcm5RWG9Cbk5JOHMrajBJeVpRMjlabWQ4Q0xMcW1na0lPVk91YWNDb2tYdktEV2tVbWtCeVJPNkx3QT09Il19..cHbVVVD8FN5e9iVCWGQCOy9BlpWKZRgw-xGuZ1N3J_v3uRNl-CsgZb4ILpqdnWsk-l0rZQsfLB64CkogBolhn6-Z_Yk9uwFABhsGJV296wlSNRl5nbawIPeutns_bY1TK9JLPWTXObOIGPHWGDgEAlvMuYbuJtzMxeEFebSyPr_ejovpxbmGVxxo5dp2u6nzICsuCjB594w43i5Ylk1fCMq3qVgmTQuda-fEWFeiTaY-olg6vvf7hokofGEhwNaPP8acX8S6bKw8Mg8uNKvREM4C2XTidhsn1V25adSLJX6Va0p4J_9MlhTlSaOug58UrQSbkU0gK-PD0SMqGBQZKlum2dgorXefH65vA-DBeKLQP9-Ao8KqE4Hn_y2-luQunJ-1TPLZ60ch6KKk548RBRY4uBStaHpZJhb3Ez9A6s_A4ap1tXOe_wRspY-fnYbcytkaSN945gCG48bHywl4cRpq_qv0MdOWwQeUXCtWTp7Sh56Y-4x4nmhKZTTdxZ0H
</pre>

**4. base64 the JWS and add the Signature element to the Bundle**

- The `Signature.type.code` elements SHALL contain the same values as the "srCms" header ids.
- The `Signature.when` SHALL match the "Sigt" header timestamp
- The `Signature.who` SHALL match the "srCms" Signer Commitments header id.
- The canonicalization method `application/fhir+json;canonicalization=http://hl7.org/fhir/canonicalization/json#document`  SHALL be indicated in the `Signature.targetFormat` element.
- JWS mime type `application/jose` SHALL be indicated in the `Signature.sigFormat` element.
- The `Signature.data` element is the base64 signature value 

this is what would be returned in response to a direct query over-the-wire


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
            "who": {
              "identifier": {
                "system": "http://hl7.org/fhir/sid/us-npi",
                "type": {
                  "coding": [
                    {
                      "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                      "code": "NPI"
                    }
                  ]
                },
                "value": "9941339100"
              },
              "display": "John Hancock, MD"
            },
            "onBehalfOf": {
              "identifier": {
                "system": "http://hl7.org/fhir/sid/us-npi",
                "value": "1234567893"
              }
            },
            "targetFormat": "application/fhir+json;canonicalization=http://hl7.org/fhir/canonicalization/json#document",
            "sigFormat": "application/jose",
            "data": b64_jws,
             }
             
document_bundle = loads(payload)
document_bundle['id'] = document_bundle_id # add id back in
document_bundle['meta'] = document_bundle_meta # add meta back in
document_bundle['signature'] = sig_element
print(dumps(document_bundle, indent=2))
```
<pre  style="border:0; background:white; overflow-wrap:break-word;">
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
              "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource \"17a80a8d-4cf1-4deb-a1fd-2db1130e5f76\" </p></div><p><b>status</b>: final</p><p><b>type</b>: Medical records <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://loinc.org/\">LOINC</a>#11503-0)</span></p><p><b>encounter</b>: <a href=\"#Encounter_5ce5c83a-000f-47d2-941c-039358cc9112\">See above (urn:uuid:5ce5c83a-000f-47d2-941c-039358cc9112: Example Encounter)</a></p><p><b>date</b>: 2021-10-25T20:16:29-07:00</p><p><b>author</b>: <a href=\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\">See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: Example Practitioner)</a></p><p><b>title</b>: Active Conditions</p><h3>Attesters</h3><table class=\"grid\"><tr><td>-</td><td><b>Mode</b></td><td><b>Time</b></td><td><b>Party</b></td></tr><tr><td>*</td><td>legal</td><td>2021-10-25T20:16:29-07:00</td><td><a href=\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\">See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: Example Practitioner)</a></td></tr></table></div>",
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
              "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource \"0820c16d-91de-4dfa-a3a6-f140a516a9bc\" Updated \"2013-05-05T16:13:03Z\" </p></div><p><b>name</b>: John Hancock </p></div>",
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
              "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource \"970af6c9-5bbd-4067-b6c1-d9b2c823aece\" </p></div><p><b>active</b>: true</p><p><b>name</b>: CDEX Example Patient</p></div>",
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
              "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource \"014a68ec-d691-49e0-b980-91b0d924e570\" </p></div><p><b>identifier</b>: id: 1</p><p><b>clinicalStatus</b>: Active <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/3.0.0/CodeSystem-condition-clinical.html\">Condition Clinical Status Codes</a>#active)</span></p><p><b>category</b>: Problem <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://browser.ihtsdotools.org/\">SNOMED CT</a>#55607006; <a href=\"https://loinc.org/\">LOINC</a>#75326-9)</span></p><p><b>code</b>: Type 2 Diabetes Mellitus <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://browser.ihtsdotools.org/\">SNOMED CT</a>#44054006)</span></p><p><b>subject</b>: <a href=\"#Patient_970af6c9-5bbd-4067-b6c1-d9b2c823aece\">See above (urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece)</a></p><p><b>onset</b>: 2006-01-01</p><p><b>asserter</b>: <a href=\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\">See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc)</a></p></div>",
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
              "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource \"5ce5c83a-000f-47d2-941c-039358cc9112\" </p></div><p><b>status</b>: finished</p><p><b>class</b>: emergency (Details: http://terminology.hl7.org/CodeSystem/v3-ActCode code EMER = 'emergency', stated as 'null')</p><p><b>type</b>: Unknown (qualifier value) <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://browser.ihtsdotools.org/\">SNOMED CT</a>#261665006)</span></p><p><b>subject</b>: <a href=\"#Patient_970af6c9-5bbd-4067-b6c1-d9b2c823aece\">See above (urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece: CDEX Example Patient)</a></p><h3>Participants</h3><table class=\"grid\"><tr><td>-</td><td><b>Individual</b></td></tr><tr><td>*</td><td><a href=\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\">See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: John Hancock)</a></td></tr></table><p><b>period</b>: 2021-10-25T20:10:29-07:00 --&gt; 2021-10-25T20:16:29-07:00</p><p><b>serviceProvider</b>: <a href=\"#Organization_e37f004b-dc10-422b-b833-cdaa10a055a3\">See above (urn:uuid:e37f004b-dc10-422b-b833-cdaa10a055a3: CDEX Example Organization)</a></p></div>",
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
              "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource \"e37f004b-dc10-422b-b833-cdaa10a055a3\" </p></div><p><b>active</b>: true</p><p><b>name</b>: CDEX Example Organization</p><p><b>telecom</b>: ph: (+1) 555-555-5555, <a href=\"mailto:customer-service@example.org\">customer-service@example.org</a></p><p><b>address</b>: 1 CDEX Lane Boston MA 01002 USA </p></div>",
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
          "identifier": {
            "system": "http://hl7.org/fhir/sid/us-npi",
            "type": {
              "coding": [
                {
                  "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                  "code": "NPI"
                }
              ]
            },
            "value": "9941339100"
          },
          "display": "John Hancock, MD"
        },
        "onBehalfOf": {
          "identifier": {
            "system": "http://hl7.org/fhir/sid/us-npi",
            "value": "1234567893"
          }
        },
        "targetFormat": "application/fhir+json;canonicalization=http://hl7.org/fhir/canonicalization/json#document",
        "sigFormat": "application/jose",
        "data": "ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNkltVTJaV1prWWpNMU1HSTJPV0l6TmpsaE5ETmhaVFl3TVRVMFpURTNaak01WVdNM05XVmlOVGdpTENKcmRIa2lPaUpTVXlJc0luTnBaMVFpT2lJeU1ESXdMVEV3TFRJelZEQTBPalUwT2pVMkxqQTBPQ3N3TURvd01DSXNJbk55UTIxeklqcGJleUpqYjIxdFNXUWlPbnNpWkdWell5STZJbFpsY21sbWFXTmhkR2x2YmlCVGFXZHVZWFIxY21VaUxDSnBaQ0k2SW5WeWJqcHZhV1E2TVM0eUxqZzBNQzR4TURBMk5TNHhMakV5TGpFdU5TSjlMQ0pqYjIxdFVYVmhiSE1pT2xzaVZtVnlhV1pwWTJGMGFXOXVJRzltSUcxbFpHbGpZV3dnY21WamIzSmtJR2x1ZEdWbmNtbDBlU0pkZlYwc0luUjVjQ0k2SWtwWFZDSXNJbmcxWXlJNld5Sk5TVWxHWlZSRFEwRXJSMmRCZDBsQ1FXZEpWVTlqUm5GTVQwSnRkRGRXVWpaNU5FWkhiakF3VVZOR1RWaEtaM2RFVVZsS1MyOWFTV2gyWTA1QlVVVk1RbEZCZDJkaFdYaERla0ZLUW1kT1ZrSkJXVlJCYkZaVVRWSlpkMFpCV1VSV1VWRkpSRUV4VGxsWVRucFpWMDV2WkZoT2JHUklVbnBOVVRoM1JGRlpSRlpSVVVoRVFWcERZak5PTUdJeU5IaElWRUZpUW1kT1ZrSkJiMDFHUlZZMFdWY3hkMkpIVldkVU0wcHVXVmMxY0dWdFJqQmhWemwxVFZOSmQwbEJXVVJXVVZGRVJFSnNSRkpGVmxsSlJWWTBXVmN4ZDJKSFZXZFVNMHB1V1ZjMWNHVnRSakJoVnpsMVRWTnpkMHRSV1VwTGIxcEphSFpqVGtGUmEwSkdhSGhxWkZoT01HSXlNV3hqYVRGNldsaEtNbUZYVG14UlIxWTBXVmN4ZDJKSFZYVmlNMHB1VFVJMFdFUlVTVEZOUkdONVRrUkZORTFVVVRCTlJtOVlSRlJKTWsxRVkzaFBWRVUwVFZSUk1FMUdiM2RuWVZsNFEzcEJTa0puVGxaQ1FWbFVRV3hXVkUxU1dYZEdRVmxFVmxGUlNVUkJNVTVaV0U1NldWZE9iMlJZVG14a1NGSjZUVkU0ZDBSUldVUldVVkZJUkVGYVEySXpUakJpTWpSNFNGUkJZa0puVGxaQ1FXOU5Sa1ZXTkZsWE1YZGlSMVZuVkROS2JsbFhOWEJsYlVZd1lWYzVkVTFUU1hkSlFWbEVWbEZSUkVSQ2JFUlNSVlpaU1VWV05GbFhNWGRpUjFWblZETktibGxYTlhCbGJVWXdZVmM1ZFUxVGMzZExVVmxLUzI5YVNXaDJZMDVCVVd0Q1JtaDRhbVJZVGpCaU1qRnNZMmt4ZWxwWVNqSmhWMDVzVVVkV05GbFhNWGRpUjFWMVlqTktiazFKU1VKdmFrRk9RbWRyY1docmFVYzVkekJDUVZGRlJrRkJUME5CV1RoQlRVbEpRbWxuUzBOQldVVkJjblI1U0VsbFJXMXRNVTFwTW1sU04yeFNWemxPVUhoQmVWTTVRbWc0VUhoRk1XSkdTMUJpVW04eFFsZGtSbGx2YzBSQlJFMWplR1JvT1dwMWVXTnphV2hHUlcwdmREbHVZMEpsUW1WTVNURlZkWHBGWWk5TEswWlhNV0ZLYm1acksyRmFla0V5TVhCbk1Yb3djbEpxTjJsVGFIQkxkemhtTUdGcGFIcGhWR2xoUWs5c1UzTmpiMWxFVjJWQ2VUZHdaVFZSTDJWTU4xWlNkWEZuYkZwb1ZtczNXa3hUY0hjNGVHSldWRzlHVUZsNU1rbG9OVFozYldRMGVDdDNORWs1UkZORGMyMXBSVVV4ZDNSWGRWcDBaVlpzWjJWalprMXpXUzlZZW05NlNFSlVhMnMwUm5Kb09GQjRhaTh6YTNaWlZGbFZOVEpxYzJONlFVbE1SR3h3VlVzMFoyRTNXRWROYnpJelVXOTFXR1JHV0ZkSk9FdE5ObGhtVDFKWFEzRlhWU3N5VmpSQ09VMXVhbXBIT0dweVR5dFBRMFJJVVVoS2NVSjRjbXROV1ZjclIydGlhRUp4T0ZsUGJtZFJVVWd2ZEZvNFEybzRkbVl3V2xoRlVXOTFNRXhYYlc5V1RtWmFXWFZ4UTBkRVNqVkpaekJzUVVSdGJTdHNRbmQwVTJWTk9WQndhbkV3WmxaWU5DOTFLeXR2YnpNMlRGbHBibmRPYjBKQmJUTnlVV3hDVGtrMVRWVjNWazl5Y25aUGFHbFhaRmwyV1ZOcU0yWjNRMnRpTVdGTFFtOW1SbkZRVFhJekwyNVRLek5XVDB4blIzQTNkamRoZEVOVVpsZEhOMlo0WmpWRk9IWm9NamQ1TVdweE0wWlFTMUJaTURCeVRuZHpObFl6VVZwMVRsaEJaMDFDUVVGSGFtZGFkM2RuV210M1ExRlpSRlpTTUZSQ1FVbDNRVVJCVEVKblRsWklVVGhGUWtGTlEwSmxRWGRaUVZsRVZsSXdVa0pHYTNkV05FbFFaRE5rTTB4dFZqUlpWekYzWWtkVmRXSXpTbTV2UW10SFExZERSMU5CUjBjclZuTkZRbkZCVFVSQmIzaE5hazB3VGxSWk0wOUVhM3BvYVd4dlpFaFNkMk42YjNaTU1sWTBXVmN4ZDJKSFZYVmlNMHB1VERKYWIyRllTWFpVTTBwdVdWYzFjR1Z0UmpCaFZ6bDFUSHBGZVUxNlFXUkNaMDVXU0ZFMFJVWm5VVlUxZFM5aVRsRjBjSE15Yld0UGRWbENWazlHTDA5aGVERTJNV2QzUkZGWlNrdHZXa2xvZG1OT1FWRkZURUpSUVVSblowZENRVUpwVEU5Vk16bE9SWGxUZWxwVFIzb3lZVTVvWWsxNlZWWTFVbUZVZDNKd1JIaEVkbGxxUkZnemFrVlFMMnB6YldvMEwzQk9LMHcxVWxsQ1dITkNabGw0VTFWMVlsRk1aVloyYTJZMVpuWXJiMGR5YldWRFZ5dG1XRGg1UlRGeWJDdHhPREZEUTB3clVUaE1UMDk2UVZwR2RVVmxXVVU1YVdWamVsazNaazh4T0Uxd1JqaHVRekUwUTBSUllqWkVUakV3VVdGQmRHSm9WRVpoYTFwbFQzRmFZVlZuVkc5RVprbE9jMjQzYW5waEwySndkREZMWlhVMWRsVnpkVEZ4Um1kcVFYQjZRVFlyVFdGc1NVNVZhMGh0WVRKR1N5dDZNbGxtZVRCWEwwNW9kWEJpVEdOWFJXNHhVbmwxVlVKVVVYZHpjMjA1ZDFKUVJFVXZURzlUVlVFemNHMXRjVkJFYkRnM1pEbDBSMFpFU3k5NWJGRlVkV0Z4YkRWMFJqQXliR3A2T0hkWlVXbFRVbVkxYm5wNGNWUnRkRzVOUTIxMmFIbGhlRGMxYmpVd2RHOHZWRzQwYkdndmFqRnBhMjhyZDBOQlYxUk5RMDVyWWl0dE5FY3hiWE5rYjFWWmJrVlpiaTlVYVhwWE9YWkxNMHhvVmxSWE5WcGtTU3QxVm5saGMyUkNhRkpNYjNsc2QxbHBaRlZIUTJGb2RrcG1SRk5IYXpCNFV6YzBhRlZZWWpJeU0wRnRlbWxUUzBVelZFWlFlRk51V2tWMk0zcHBPRzFQYTNwelRWTjFZbXB1Y0VweGNtNVJXRzlDYms1Sk9ITXJhakJKZVZwUk1qbGFiV1E0UTB4TWNXMW5hMGxQVms5MVlXTkRiMnRZZGt0RVYydFZiV3RDZVZKUE5reDNRVDA5SWwxOS4uY0hiVlZWRDhGTjVlOWlWQ1dHUUNPeTlCbHBXS1pSZ3cteEd1WjFOM0pfdjN1Uk5sLUNzZ1piNElMcHFkbldzay1sMHJaUXNmTEI2NENrb2dCb2xobjYtWl9Zazl1d0ZBQmhzR0pWMjk2d2xTTlJsNW5iYXdJUGV1dG5zX2JZMVRLOUpMUFdUWE9iT0lHUEhXR0RnRUFsdk11WWJ1SnR6TXhlRUZlYlN5UHJfZWpvdnB4Ym1HVnh4bzVkcDJ1Nm56SUNzdUNqQjU5NHc0M2k1WWxrMWZDTXEzcVZnbVRRdWRhLWZFV0ZlaVRhWS1vbGc2dnZmN2hva29mR0Vod05hUFA4YWNYOFM2Ykt3OE1nOHVOS3ZSRU00QzJYVGlkaHNuMVYyNWFkU0xKWDZWYTBwNEpfOU1saFRsU2FPdWc1OFVyUVNia1UwZ0stUEQwU01xR0JRWktsdW0yZGdvclhlZkg2NXZBLURCZUtMUVA5LUFvOEtxRTRIbl95Mi1sdVF1bkotMVRQTFo2MGNoNktLazU0OFJCUlk0dUJTdGFIcFpKaGIzRXo5QTZzX0E0YXAxdFhPZV93UnNwWS1mblliY3l0a2FTTjk0NWdDRzQ4Ykh5d2w0Y1JwcV9xdjBNZE9Xd1FlVVhDdFdUcDdTaDU2WS00eDRubWhLWlRUZHhaMEg="
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



<pre  style="border:0; background:white; overflow-wrap:break-word;">
    {'type': [{'system': 'urn:iso-astm:E1762-95:2013',
       'code': '1.2.840.10065.1.12.1.5',
       'display': 'Verification Signature'}],
     'when': '2021-10-05T22:42:19-07:00',
     'who': {'identifier': {'system': 'http://hl7.org/fhir/sid/us-npi',
       'type': {'coding': [{'system': 'http://terminology.hl7.org/CodeSystem/v2-0203',
          'code': 'NPI'}]},
       'value': '9941339100'},
      'display': 'John Hancock, MD'},
     'onBehalfOf': {'identifier': {'system': 'http://hl7.org/fhir/sid/us-npi',
       'value': '1234567893'}},
     'targetFormat': 'application/fhir+json;canonicalization=http://hl7.org/fhir/canonicalization/json#document',
     'sigFormat': 'application/jose',
     'data': 'ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNkltVTJaV1prWWpNMU1HSTJPV0l6TmpsaE5ETmhaVFl3TVRVMFpURTNaak01WVdNM05XVmlOVGdpTENKcmRIa2lPaUpTVXlJc0luTnBaMVFpT2lJeU1ESXdMVEV3TFRJelZEQTBPalUwT2pVMkxqQTBPQ3N3TURvd01DSXNJbk55UTIxeklqcGJleUpqYjIxdFNXUWlPbnNpWkdWell5STZJbFpsY21sbWFXTmhkR2x2YmlCVGFXZHVZWFIxY21VaUxDSnBaQ0k2SW5WeWJqcHZhV1E2TVM0eUxqZzBNQzR4TURBMk5TNHhMakV5TGpFdU5TSjlMQ0pqYjIxdFVYVmhiSE1pT2xzaVZtVnlhV1pwWTJGMGFXOXVJRzltSUcxbFpHbGpZV3dnY21WamIzSmtJR2x1ZEdWbmNtbDBlU0pkZlYwc0luUjVjQ0k2SWtwWFZDSXNJbmcxWXlJNld5Sk5TVWxHWlZSRFEwRXJSMmRCZDBsQ1FXZEpWVTlqUm5GTVQwSnRkRGRXVWpaNU5FWkhiakF3VVZOR1RWaEtaM2RFVVZsS1MyOWFTV2gyWTA1QlVVVk1RbEZCZDJkaFdYaERla0ZLUW1kT1ZrSkJXVlJCYkZaVVRWSlpkMFpCV1VSV1VWRkpSRUV4VGxsWVRucFpWMDV2WkZoT2JHUklVbnBOVVRoM1JGRlpSRlpSVVVoRVFWcERZak5PTUdJeU5IaElWRUZpUW1kT1ZrSkJiMDFHUlZZMFdWY3hkMkpIVldkVU0wcHVXVmMxY0dWdFJqQmhWemwxVFZOSmQwbEJXVVJXVVZGRVJFSnNSRkpGVmxsSlJWWTBXVmN4ZDJKSFZXZFVNMHB1V1ZjMWNHVnRSakJoVnpsMVRWTnpkMHRSV1VwTGIxcEphSFpqVGtGUmEwSkdhSGhxWkZoT01HSXlNV3hqYVRGNldsaEtNbUZYVG14UlIxWTBXVmN4ZDJKSFZYVmlNMHB1VFVJMFdFUlVTVEZOUkdONVRrUkZORTFVVVRCTlJtOVlSRlJKTWsxRVkzaFBWRVUwVFZSUk1FMUdiM2RuWVZsNFEzcEJTa0puVGxaQ1FWbFVRV3hXVkUxU1dYZEdRVmxFVmxGUlNVUkJNVTVaV0U1NldWZE9iMlJZVG14a1NGSjZUVkU0ZDBSUldVUldVVkZJUkVGYVEySXpUakJpTWpSNFNGUkJZa0puVGxaQ1FXOU5Sa1ZXTkZsWE1YZGlSMVZuVkROS2JsbFhOWEJsYlVZd1lWYzVkVTFUU1hkSlFWbEVWbEZSUkVSQ2JFUlNSVlpaU1VWV05GbFhNWGRpUjFWblZETktibGxYTlhCbGJVWXdZVmM1ZFUxVGMzZExVVmxLUzI5YVNXaDJZMDVCVVd0Q1JtaDRhbVJZVGpCaU1qRnNZMmt4ZWxwWVNqSmhWMDVzVVVkV05GbFhNWGRpUjFWMVlqTktiazFKU1VKdmFrRk9RbWRyY1docmFVYzVkekJDUVZGRlJrRkJUME5CV1RoQlRVbEpRbWxuUzBOQldVVkJjblI1U0VsbFJXMXRNVTFwTW1sU04yeFNWemxPVUhoQmVWTTVRbWc0VUhoRk1XSkdTMUJpVW04eFFsZGtSbGx2YzBSQlJFMWplR1JvT1dwMWVXTnphV2hHUlcwdmREbHVZMEpsUW1WTVNURlZkWHBGWWk5TEswWlhNV0ZLYm1acksyRmFla0V5TVhCbk1Yb3djbEpxTjJsVGFIQkxkemhtTUdGcGFIcGhWR2xoUWs5c1UzTmpiMWxFVjJWQ2VUZHdaVFZSTDJWTU4xWlNkWEZuYkZwb1ZtczNXa3hUY0hjNGVHSldWRzlHVUZsNU1rbG9OVFozYldRMGVDdDNORWs1UkZORGMyMXBSVVV4ZDNSWGRWcDBaVlpzWjJWalprMXpXUzlZZW05NlNFSlVhMnMwUm5Kb09GQjRhaTh6YTNaWlZGbFZOVEpxYzJONlFVbE1SR3h3VlVzMFoyRTNXRWROYnpJelVXOTFXR1JHV0ZkSk9FdE5ObGhtVDFKWFEzRlhWU3N5VmpSQ09VMXVhbXBIT0dweVR5dFBRMFJJVVVoS2NVSjRjbXROV1ZjclIydGlhRUp4T0ZsUGJtZFJVVWd2ZEZvNFEybzRkbVl3V2xoRlVXOTFNRXhYYlc5V1RtWmFXWFZ4UTBkRVNqVkpaekJzUVVSdGJTdHNRbmQwVTJWTk9WQndhbkV3WmxaWU5DOTFLeXR2YnpNMlRGbHBibmRPYjBKQmJUTnlVV3hDVGtrMVRWVjNWazl5Y25aUGFHbFhaRmwyV1ZOcU0yWjNRMnRpTVdGTFFtOW1SbkZRVFhJekwyNVRLek5XVDB4blIzQTNkamRoZEVOVVpsZEhOMlo0WmpWRk9IWm9NamQ1TVdweE0wWlFTMUJaTURCeVRuZHpObFl6VVZwMVRsaEJaMDFDUVVGSGFtZGFkM2RuV210M1ExRlpSRlpTTUZSQ1FVbDNRVVJCVEVKblRsWklVVGhGUWtGTlEwSmxRWGRaUVZsRVZsSXdVa0pHYTNkV05FbFFaRE5rTTB4dFZqUlpWekYzWWtkVmRXSXpTbTV2UW10SFExZERSMU5CUjBjclZuTkZRbkZCVFVSQmIzaE5hazB3VGxSWk0wOUVhM3BvYVd4dlpFaFNkMk42YjNaTU1sWTBXVmN4ZDJKSFZYVmlNMHB1VERKYWIyRllTWFpVTTBwdVdWYzFjR1Z0UmpCaFZ6bDFUSHBGZVUxNlFXUkNaMDVXU0ZFMFJVWm5VVlUxZFM5aVRsRjBjSE15Yld0UGRWbENWazlHTDA5aGVERTJNV2QzUkZGWlNrdHZXa2xvZG1OT1FWRkZURUpSUVVSblowZENRVUpwVEU5Vk16bE9SWGxUZWxwVFIzb3lZVTVvWWsxNlZWWTFVbUZVZDNKd1JIaEVkbGxxUkZnemFrVlFMMnB6YldvMEwzQk9LMHcxVWxsQ1dITkNabGw0VTFWMVlsRk1aVloyYTJZMVpuWXJiMGR5YldWRFZ5dG1XRGg1UlRGeWJDdHhPREZEUTB3clVUaE1UMDk2UVZwR2RVVmxXVVU1YVdWamVsazNaazh4T0Uxd1JqaHVRekUwUTBSUllqWkVUakV3VVdGQmRHSm9WRVpoYTFwbFQzRmFZVlZuVkc5RVprbE9jMjQzYW5waEwySndkREZMWlhVMWRsVnpkVEZ4Um1kcVFYQjZRVFlyVFdGc1NVNVZhMGh0WVRKR1N5dDZNbGxtZVRCWEwwNW9kWEJpVEdOWFJXNHhVbmwxVlVKVVVYZHpjMjA1ZDFKUVJFVXZURzlUVlVFemNHMXRjVkJFYkRnM1pEbDBSMFpFU3k5NWJGRlVkV0Z4YkRWMFJqQXliR3A2T0hkWlVXbFRVbVkxYm5wNGNWUnRkRzVOUTIxMmFIbGhlRGMxYmpVd2RHOHZWRzQwYkdndmFqRnBhMjhyZDBOQlYxUk5RMDVyWWl0dE5FY3hiWE5rYjFWWmJrVlpiaTlVYVhwWE9YWkxNMHhvVmxSWE5WcGtTU3QxVm5saGMyUkNhRkpNYjNsc2QxbHBaRlZIUTJGb2RrcG1SRk5IYXpCNFV6YzBhRlZZWWpJeU0wRnRlbWxUUzBVelZFWlFlRk51V2tWMk0zcHBPRzFQYTNwelRWTjFZbXB1Y0VweGNtNVJXRzlDYms1Sk9ITXJhakJKZVZwUk1qbGFiV1E0UTB4TWNXMW5hMGxQVms5MVlXTkRiMnRZZGt0RVYydFZiV3RDZVZKUE5reDNRVDA5SWwxOS4uY0hiVlZWRDhGTjVlOWlWQ1dHUUNPeTlCbHBXS1pSZ3cteEd1WjFOM0pfdjN1Uk5sLUNzZ1piNElMcHFkbldzay1sMHJaUXNmTEI2NENrb2dCb2xobjYtWl9Zazl1d0ZBQmhzR0pWMjk2d2xTTlJsNW5iYXdJUGV1dG5zX2JZMVRLOUpMUFdUWE9iT0lHUEhXR0RnRUFsdk11WWJ1SnR6TXhlRUZlYlN5UHJfZWpvdnB4Ym1HVnh4bzVkcDJ1Nm56SUNzdUNqQjU5NHc0M2k1WWxrMWZDTXEzcVZnbVRRdWRhLWZFV0ZlaVRhWS1vbGc2dnZmN2hva29mR0Vod05hUFA4YWNYOFM2Ykt3OE1nOHVOS3ZSRU00QzJYVGlkaHNuMVYyNWFkU0xKWDZWYTBwNEpfOU1saFRsU2FPdWc1OFVyUVNia1UwZ0stUEQwU01xR0JRWktsdW0yZGdvclhlZkg2NXZBLURCZUtMUVA5LUFvOEtxRTRIbl95Mi1sdVF1bkotMVRQTFo2MGNoNktLazU0OFJCUlk0dUJTdGFIcFpKaGIzRXo5QTZzX0E0YXAxdFhPZV93UnNwWS1mblliY3l0a2FTTjk0NWdDRzQ4Ykh5d2w0Y1JwcV9xdjBNZE9Xd1FlVVhDdFdUcDdTaDU2WS00eDRubWhLWlRUZHhaMEg='}
</pre>


**2. Canonicalize the bundle using IETF JSON Canonicalization Scheme (JCS):**

- Remove the id and meta elements if present before canonicalization


```python
document_bundle_id = document_bundle.pop("id") # remove id
document_bundle_meta = document_bundle.pop("meta") # remove meta
canonical_bundle = canonicalize(document_bundle)
canonical_bundle
```



<pre  style="border:0; background:white; overflow-wrap:break-word;">
    b'{"entry":[{"fullUrl":"urn:uuid:17a80a8d-4cf1-4deb-a1fd-2db1130e5f76","resource":{"attester":[{"mode":"legal","party":{"display":"Example Practitioner","reference":"urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"},"time":"2021-10-25T20:16:29-07:00"}],"author":[{"display":"Example Practitioner","reference":"urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"}],"date":"2021-10-25T20:16:29-07:00","encounter":{"display":"Example Encounter","reference":"urn:uuid:5ce5c83a-000f-47d2-941c-039358cc9112"},"id":"17a80a8d-4cf1-4deb-a1fd-2db1130e5f76","resourceType":"Composition","section":[{"entry":[{"reference":"urn:uuid:014a68ec-d691-49e0-b980-91b0d924e570"}],"title":"Active Condition 1"}],"status":"final","subject":{"display":"Example Patient","reference":"urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece"},"text":{"div":"<div xmlns=\\"http://www.w3.org/1999/xhtml\\"><p><b>Generated Narrative</b></p><div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"><p style=\\"margin-bottom: 0px\\">Resource \\"17a80a8d-4cf1-4deb-a1fd-2db1130e5f76\\" </p></div><p><b>status</b>: final</p><p><b>type</b>: Medical records <span style=\\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\\"> (<a href=\\"https://loinc.org/\\">LOINC</a>#11503-0)</span></p><p><b>encounter</b>: <a href=\\"#Encounter_5ce5c83a-000f-47d2-941c-039358cc9112\\">See above (urn:uuid:5ce5c83a-000f-47d2-941c-039358cc9112: Example Encounter)</a></p><p><b>date</b>: 2021-10-25T20:16:29-07:00</p><p><b>author</b>: <a href=\\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\\">See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: Example Practitioner)</a></p><p><b>title</b>: Active Conditions</p><h3>Attesters</h3><table class=\\"grid\\"><tr><td>-</td><td><b>Mode</b></td><td><b>Time</b></td><td><b>Party</b></td></tr><tr><td>*</td><td>legal</td><td>2021-10-25T20:16:29-07:00</td><td><a href=\\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\\">See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: Example Practitioner)</a></td></tr></table></div>","status":"generated"},"title":"Active Conditions","type":{"coding":[{"code":"11503-0","system":"http://loinc.org"}],"text":"Medical records"}}},{"fullUrl":"urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc","resource":{"id":"0820c16d-91de-4dfa-a3a6-f140a516a9bc","meta":{"lastUpdated":"2013-05-05T16:13:03Z"},"name":[{"family":"Hancock","given":["John"]}],"resourceType":"Practitioner","text":{"div":"<div xmlns=\\"http://www.w3.org/1999/xhtml\\"><p><b>Generated Narrative</b></p><div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"><p style=\\"margin-bottom: 0px\\">Resource \\"0820c16d-91de-4dfa-a3a6-f140a516a9bc\\" Updated \\"2013-05-05T16:13:03Z\\" </p></div><p><b>name</b>: John Hancock </p></div>","status":"generated"}}},{"fullUrl":"urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece","resource":{"active":true,"id":"970af6c9-5bbd-4067-b6c1-d9b2c823aece","name":[{"family":"Patient","given":["CDEX Example"],"text":"CDEX Example Patient"}],"resourceType":"Patient","text":{"div":"<div xmlns=\\"http://www.w3.org/1999/xhtml\\"><p><b>Generated Narrative</b></p><div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"><p style=\\"margin-bottom: 0px\\">Resource \\"970af6c9-5bbd-4067-b6c1-d9b2c823aece\\" </p></div><p><b>active</b>: true</p><p><b>name</b>: CDEX Example Patient</p></div>","status":"generated"}}},{"fullUrl":"urn:uuid:014a68ec-d691-49e0-b980-91b0d924e570","resource":{"asserter":{"reference":"urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"},"category":[{"coding":[{"code":"55607006","display":"Problem","system":"http://snomed.info/sct"},{"code":"75326-9","display":"Problem","system":"http://loinc.org"}]}],"clinicalStatus":{"coding":[{"code":"active","system":"http://terminology.hl7.org/CodeSystem/condition-clinical"}]},"code":{"coding":[{"code":"44054006","display":"Type 2 Diabetes Mellitus","system":"http://snomed.info/sct"}]},"id":"014a68ec-d691-49e0-b980-91b0d924e570","identifier":[{"system":"urn:oid:1.3.6.1.4.1.22812.4.111.0.4.1.2.1","value":"1"}],"onsetDateTime":"2006","resourceType":"Condition","subject":{"reference":"urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece"},"text":{"div":"<div xmlns=\\"http://www.w3.org/1999/xhtml\\"><p><b>Generated Narrative</b></p><div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"><p style=\\"margin-bottom: 0px\\">Resource \\"014a68ec-d691-49e0-b980-91b0d924e570\\" </p></div><p><b>identifier</b>: id: 1</p><p><b>clinicalStatus</b>: Active <span style=\\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\\"> (<a href=\\"http://terminology.hl7.org/3.0.0/CodeSystem-condition-clinical.html\\">Condition Clinical Status Codes</a>#active)</span></p><p><b>category</b>: Problem <span style=\\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\\"> (<a href=\\"https://browser.ihtsdotools.org/\\">SNOMED CT</a>#55607006; <a href=\\"https://loinc.org/\\">LOINC</a>#75326-9)</span></p><p><b>code</b>: Type 2 Diabetes Mellitus <span style=\\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\\"> (<a href=\\"https://browser.ihtsdotools.org/\\">SNOMED CT</a>#44054006)</span></p><p><b>subject</b>: <a href=\\"#Patient_970af6c9-5bbd-4067-b6c1-d9b2c823aece\\">See above (urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece)</a></p><p><b>onset</b>: 2006-01-01</p><p><b>asserter</b>: <a href=\\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\\">See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc)</a></p></div>","status":"generated"}}},{"fullUrl":"urn:uuid:5ce5c83a-000f-47d2-941c-039358cc9112","resource":{"class":{"code":"EMER","system":"http://terminology.hl7.org/CodeSystem/v3-ActCode"},"id":"5ce5c83a-000f-47d2-941c-039358cc9112","participant":[{"individual":{"display":"John Hancock","reference":"urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc"}}],"period":{"end":"2021-10-25T20:16:29-07:00","start":"2021-10-25T20:10:29-07:00"},"resourceType":"Encounter","serviceProvider":{"display":"CDEX Example Organization","reference":"urn:uuid:e37f004b-dc10-422b-b833-cdaa10a055a3"},"status":"finished","subject":{"display":"CDEX Example Patient","reference":"urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece"},"text":{"div":"<div xmlns=\\"http://www.w3.org/1999/xhtml\\"><p><b>Generated Narrative</b></p><div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"><p style=\\"margin-bottom: 0px\\">Resource \\"5ce5c83a-000f-47d2-941c-039358cc9112\\" </p></div><p><b>status</b>: finished</p><p><b>class</b>: emergency (Details: http://terminology.hl7.org/CodeSystem/v3-ActCode code EMER = \'emergency\', stated as \'null\')</p><p><b>type</b>: Unknown (qualifier value) <span style=\\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\\"> (<a href=\\"https://browser.ihtsdotools.org/\\">SNOMED CT</a>#261665006)</span></p><p><b>subject</b>: <a href=\\"#Patient_970af6c9-5bbd-4067-b6c1-d9b2c823aece\\">See above (urn:uuid:970af6c9-5bbd-4067-b6c1-d9b2c823aece: CDEX Example Patient)</a></p><h3>Participants</h3><table class=\\"grid\\"><tr><td>-</td><td><b>Individual</b></td></tr><tr><td>*</td><td><a href=\\"#Practitioner_0820c16d-91de-4dfa-a3a6-f140a516a9bc\\">See above (urn:uuid:0820c16d-91de-4dfa-a3a6-f140a516a9bc: John Hancock)</a></td></tr></table><p><b>period</b>: 2021-10-25T20:10:29-07:00 --&gt; 2021-10-25T20:16:29-07:00</p><p><b>serviceProvider</b>: <a href=\\"#Organization_e37f004b-dc10-422b-b833-cdaa10a055a3\\">See above (urn:uuid:e37f004b-dc10-422b-b833-cdaa10a055a3: CDEX Example Organization)</a></p></div>","status":"generated"},"type":[{"coding":[{"code":"261665006","display":"Unknown (qualifier value)","system":"http://snomed.info/sct"}],"text":"Unknown (qualifier value)"}]}},{"fullUrl":"urn:uuid:e37f004b-dc10-422b-b833-cdaa10a055a3","resource":{"active":true,"address":[{"city":"Boston","country":"USA","line":["1 CDEX Lane"],"postalCode":"01002","state":"MA"}],"id":"e37f004b-dc10-422b-b833-cdaa10a055a3","name":"CDEX Example Organization","resourceType":"Organization","telecom":[{"system":"phone","value":"(+1) 555-555-5555"},{"system":"email","value":"customer-service@example.org"}],"text":{"div":"<div xmlns=\\"http://www.w3.org/1999/xhtml\\"><p><b>Generated Narrative</b></p><div style=\\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\\"><p style=\\"margin-bottom: 0px\\">Resource \\"e37f004b-dc10-422b-b833-cdaa10a055a3\\" </p></div><p><b>active</b>: true</p><p><b>name</b>: CDEX Example Organization</p><p><b>telecom</b>: ph: (+1) 555-555-5555, <a href=\\"mailto:customer-service@example.org\\">customer-service@example.org</a></p><p><b>address</b>: 1 CDEX Lane Boston MA 01002 USA </p></div>","status":"generated"}}}],"identifier":{"system":"urn:ietf:rfc:3986","value":"urn:uuid:c173535e-135e-48e3-ab64-38bacc68dba8"},"resourceType":"Bundle","timestamp":"2021-10-25T20:16:29-07:00","type":"document"}'
</pre>


**3. Transform canonicalize Bundle to a base64 format using the Base64-URL algorithm.**


```python
from base64 import urlsafe_b64encode
recd_b64_canonical_bundle  = urlsafe_b64encode(canonical_bundle).decode()
recd_b64_canonical_bundle = recd_b64_canonical_bundle.replace("=","")  #remove padding since decode package doesn't use them 
recd_b64_canonical_bundle
```



<pre  style="border:0; background:white; overflow-wrap:break-word;">
    'eyJlbnRyeSI6W3siZnVsbFVybCI6InVybjp1dWlkOjE3YTgwYThkLTRjZjEtNGRlYi1hMWZkLTJkYjExMzBlNWY3NiIsInJlc291cmNlIjp7ImF0dGVzdGVyIjpbeyJtb2RlIjoibGVnYWwiLCJwYXJ0eSI6eyJkaXNwbGF5IjoiRXhhbXBsZSBQcmFjdGl0aW9uZXIiLCJyZWZlcmVuY2UiOiJ1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMifSwidGltZSI6IjIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDAifV0sImF1dGhvciI6W3siZGlzcGxheSI6IkV4YW1wbGUgUHJhY3RpdGlvbmVyIiwicmVmZXJlbmNlIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIn1dLCJkYXRlIjoiMjAyMS0xMC0yNVQyMDoxNjoyOS0wNzowMCIsImVuY291bnRlciI6eyJkaXNwbGF5IjoiRXhhbXBsZSBFbmNvdW50ZXIiLCJyZWZlcmVuY2UiOiJ1cm46dXVpZDo1Y2U1YzgzYS0wMDBmLTQ3ZDItOTQxYy0wMzkzNThjYzkxMTIifSwiaWQiOiIxN2E4MGE4ZC00Y2YxLTRkZWItYTFmZC0yZGIxMTMwZTVmNzYiLCJyZXNvdXJjZVR5cGUiOiJDb21wb3NpdGlvbiIsInNlY3Rpb24iOlt7ImVudHJ5IjpbeyJyZWZlcmVuY2UiOiJ1cm46dXVpZDowMTRhNjhlYy1kNjkxLTQ5ZTAtYjk4MC05MWIwZDkyNGU1NzAifV0sInRpdGxlIjoiQWN0aXZlIENvbmRpdGlvbiAxIn1dLCJzdGF0dXMiOiJmaW5hbCIsInN1YmplY3QiOnsiZGlzcGxheSI6IkV4YW1wbGUgUGF0aWVudCIsInJlZmVyZW5jZSI6InVybjp1dWlkOjk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZSJ9LCJ0ZXh0Ijp7ImRpdiI6IjxkaXYgeG1sbnM9XCJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hodG1sXCI-PHA-PGI-R2VuZXJhdGVkIE5hcnJhdGl2ZTwvYj48L3A-PGRpdiBzdHlsZT1cImRpc3BsYXk6IGlubGluZS1ibG9jazsgYmFja2dyb3VuZC1jb2xvcjogI2Q5ZTBlNzsgcGFkZGluZzogNnB4OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQgIzhkYTFiNDsgYm9yZGVyLXJhZGl1czogNXB4OyBsaW5lLWhlaWdodDogNjAlXCI-PHAgc3R5bGU9XCJtYXJnaW4tYm90dG9tOiAwcHhcIj5SZXNvdXJjZSBcIjE3YTgwYThkLTRjZjEtNGRlYi1hMWZkLTJkYjExMzBlNWY3NlwiIDwvcD48L2Rpdj48cD48Yj5zdGF0dXM8L2I-OiBmaW5hbDwvcD48cD48Yj50eXBlPC9iPjogTWVkaWNhbCByZWNvcmRzIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vbG9pbmMub3JnL1wiPkxPSU5DPC9hPiMxMTUwMy0wKTwvc3Bhbj48L3A-PHA-PGI-ZW5jb3VudGVyPC9iPjogPGEgaHJlZj1cIiNFbmNvdW50ZXJfNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyXCI-U2VlIGFib3ZlICh1cm46dXVpZDo1Y2U1YzgzYS0wMDBmLTQ3ZDItOTQxYy0wMzkzNThjYzkxMTI6IEV4YW1wbGUgRW5jb3VudGVyKTwvYT48L3A-PHA-PGI-ZGF0ZTwvYj46IDIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDA8L3A-PHA-PGI-YXV0aG9yPC9iPjogPGEgaHJlZj1cIiNQcmFjdGl0aW9uZXJfMDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjXCI-U2VlIGFib3ZlICh1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmM6IEV4YW1wbGUgUHJhY3RpdGlvbmVyKTwvYT48L3A-PHA-PGI-dGl0bGU8L2I-OiBBY3RpdmUgQ29uZGl0aW9uczwvcD48aDM-QXR0ZXN0ZXJzPC9oMz48dGFibGUgY2xhc3M9XCJncmlkXCI-PHRyPjx0ZD4tPC90ZD48dGQ-PGI-TW9kZTwvYj48L3RkPjx0ZD48Yj5UaW1lPC9iPjwvdGQ-PHRkPjxiPlBhcnR5PC9iPjwvdGQ-PC90cj48dHI-PHRkPio8L3RkPjx0ZD5sZWdhbDwvdGQ-PHRkPjIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDA8L3RkPjx0ZD48YSBocmVmPVwiI1ByYWN0aXRpb25lcl8wODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmNcIj5TZWUgYWJvdmUgKHVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYzogRXhhbXBsZSBQcmFjdGl0aW9uZXIpPC9hPjwvdGQ-PC90cj48L3RhYmxlPjwvZGl2PiIsInN0YXR1cyI6ImdlbmVyYXRlZCJ9LCJ0aXRsZSI6IkFjdGl2ZSBDb25kaXRpb25zIiwidHlwZSI6eyJjb2RpbmciOlt7ImNvZGUiOiIxMTUwMy0wIiwic3lzdGVtIjoiaHR0cDovL2xvaW5jLm9yZyJ9XSwidGV4dCI6Ik1lZGljYWwgcmVjb3JkcyJ9fX0seyJmdWxsVXJsIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIiwicmVzb3VyY2UiOnsiaWQiOiIwODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMiLCJtZXRhIjp7Imxhc3RVcGRhdGVkIjoiMjAxMy0wNS0wNVQxNjoxMzowM1oifSwibmFtZSI6W3siZmFtaWx5IjoiSGFuY29jayIsImdpdmVuIjpbIkpvaG4iXX1dLCJyZXNvdXJjZVR5cGUiOiJQcmFjdGl0aW9uZXIiLCJ0ZXh0Ijp7ImRpdiI6IjxkaXYgeG1sbnM9XCJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hodG1sXCI-PHA-PGI-R2VuZXJhdGVkIE5hcnJhdGl2ZTwvYj48L3A-PGRpdiBzdHlsZT1cImRpc3BsYXk6IGlubGluZS1ibG9jazsgYmFja2dyb3VuZC1jb2xvcjogI2Q5ZTBlNzsgcGFkZGluZzogNnB4OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQgIzhkYTFiNDsgYm9yZGVyLXJhZGl1czogNXB4OyBsaW5lLWhlaWdodDogNjAlXCI-PHAgc3R5bGU9XCJtYXJnaW4tYm90dG9tOiAwcHhcIj5SZXNvdXJjZSBcIjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliY1wiIFVwZGF0ZWQgXCIyMDEzLTA1LTA1VDE2OjEzOjAzWlwiIDwvcD48L2Rpdj48cD48Yj5uYW1lPC9iPjogSm9obiBIYW5jb2NrIDwvcD48L2Rpdj4iLCJzdGF0dXMiOiJnZW5lcmF0ZWQifX19LHsiZnVsbFVybCI6InVybjp1dWlkOjk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZSIsInJlc291cmNlIjp7ImFjdGl2ZSI6dHJ1ZSwiaWQiOiI5NzBhZjZjOS01YmJkLTQwNjctYjZjMS1kOWIyYzgyM2FlY2UiLCJuYW1lIjpbeyJmYW1pbHkiOiJQYXRpZW50IiwiZ2l2ZW4iOlsiQ0RFWCBFeGFtcGxlIl0sInRleHQiOiJDREVYIEV4YW1wbGUgUGF0aWVudCJ9XSwicmVzb3VyY2VUeXBlIjoiUGF0aWVudCIsInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiOTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlXCIgPC9wPjwvZGl2PjxwPjxiPmFjdGl2ZTwvYj46IHRydWU8L3A-PHA-PGI-bmFtZTwvYj46IENERVggRXhhbXBsZSBQYXRpZW50PC9wPjwvZGl2PiIsInN0YXR1cyI6ImdlbmVyYXRlZCJ9fX0seyJmdWxsVXJsIjoidXJuOnV1aWQ6MDE0YTY4ZWMtZDY5MS00OWUwLWI5ODAtOTFiMGQ5MjRlNTcwIiwicmVzb3VyY2UiOnsiYXNzZXJ0ZXIiOnsicmVmZXJlbmNlIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIn0sImNhdGVnb3J5IjpbeyJjb2RpbmciOlt7ImNvZGUiOiI1NTYwNzAwNiIsImRpc3BsYXkiOiJQcm9ibGVtIiwic3lzdGVtIjoiaHR0cDovL3Nub21lZC5pbmZvL3NjdCJ9LHsiY29kZSI6Ijc1MzI2LTkiLCJkaXNwbGF5IjoiUHJvYmxlbSIsInN5c3RlbSI6Imh0dHA6Ly9sb2luYy5vcmcifV19XSwiY2xpbmljYWxTdGF0dXMiOnsiY29kaW5nIjpbeyJjb2RlIjoiYWN0aXZlIiwic3lzdGVtIjoiaHR0cDovL3Rlcm1pbm9sb2d5LmhsNy5vcmcvQ29kZVN5c3RlbS9jb25kaXRpb24tY2xpbmljYWwifV19LCJjb2RlIjp7ImNvZGluZyI6W3siY29kZSI6IjQ0MDU0MDA2IiwiZGlzcGxheSI6IlR5cGUgMiBEaWFiZXRlcyBNZWxsaXR1cyIsInN5c3RlbSI6Imh0dHA6Ly9zbm9tZWQuaW5mby9zY3QifV19LCJpZCI6IjAxNGE2OGVjLWQ2OTEtNDllMC1iOTgwLTkxYjBkOTI0ZTU3MCIsImlkZW50aWZpZXIiOlt7InN5c3RlbSI6InVybjpvaWQ6MS4zLjYuMS40LjEuMjI4MTIuNC4xMTEuMC40LjEuMi4xIiwidmFsdWUiOiIxIn1dLCJvbnNldERhdGVUaW1lIjoiMjAwNiIsInJlc291cmNlVHlwZSI6IkNvbmRpdGlvbiIsInN1YmplY3QiOnsicmVmZXJlbmNlIjoidXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlIn0sInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiMDE0YTY4ZWMtZDY5MS00OWUwLWI5ODAtOTFiMGQ5MjRlNTcwXCIgPC9wPjwvZGl2PjxwPjxiPmlkZW50aWZpZXI8L2I-OiBpZDogMTwvcD48cD48Yj5jbGluaWNhbFN0YXR1czwvYj46IEFjdGl2ZSA8c3BhbiBzdHlsZT1cImJhY2tncm91bmQ6IExpZ2h0R29sZGVuUm9kWWVsbG93OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQga2hha2lcIj4gKDxhIGhyZWY9XCJodHRwOi8vdGVybWlub2xvZ3kuaGw3Lm9yZy8zLjAuMC9Db2RlU3lzdGVtLWNvbmRpdGlvbi1jbGluaWNhbC5odG1sXCI-Q29uZGl0aW9uIENsaW5pY2FsIFN0YXR1cyBDb2RlczwvYT4jYWN0aXZlKTwvc3Bhbj48L3A-PHA-PGI-Y2F0ZWdvcnk8L2I-OiBQcm9ibGVtIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vYnJvd3Nlci5paHRzZG90b29scy5vcmcvXCI-U05PTUVEIENUPC9hPiM1NTYwNzAwNjsgPGEgaHJlZj1cImh0dHBzOi8vbG9pbmMub3JnL1wiPkxPSU5DPC9hPiM3NTMyNi05KTwvc3Bhbj48L3A-PHA-PGI-Y29kZTwvYj46IFR5cGUgMiBEaWFiZXRlcyBNZWxsaXR1cyA8c3BhbiBzdHlsZT1cImJhY2tncm91bmQ6IExpZ2h0R29sZGVuUm9kWWVsbG93OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQga2hha2lcIj4gKDxhIGhyZWY9XCJodHRwczovL2Jyb3dzZXIuaWh0c2RvdG9vbHMub3JnL1wiPlNOT01FRCBDVDwvYT4jNDQwNTQwMDYpPC9zcGFuPjwvcD48cD48Yj5zdWJqZWN0PC9iPjogPGEgaHJlZj1cIiNQYXRpZW50Xzk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZVwiPlNlZSBhYm92ZSAodXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlKTwvYT48L3A-PHA-PGI-b25zZXQ8L2I-OiAyMDA2LTAxLTAxPC9wPjxwPjxiPmFzc2VydGVyPC9iPjogPGEgaHJlZj1cIiNQcmFjdGl0aW9uZXJfMDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjXCI-U2VlIGFib3ZlICh1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMpPC9hPjwvcD48L2Rpdj4iLCJzdGF0dXMiOiJnZW5lcmF0ZWQifX19LHsiZnVsbFVybCI6InVybjp1dWlkOjVjZTVjODNhLTAwMGYtNDdkMi05NDFjLTAzOTM1OGNjOTExMiIsInJlc291cmNlIjp7ImNsYXNzIjp7ImNvZGUiOiJFTUVSIiwic3lzdGVtIjoiaHR0cDovL3Rlcm1pbm9sb2d5LmhsNy5vcmcvQ29kZVN5c3RlbS92My1BY3RDb2RlIn0sImlkIjoiNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyIiwicGFydGljaXBhbnQiOlt7ImluZGl2aWR1YWwiOnsiZGlzcGxheSI6IkpvaG4gSGFuY29jayIsInJlZmVyZW5jZSI6InVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYyJ9fV0sInBlcmlvZCI6eyJlbmQiOiIyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwIiwic3RhcnQiOiIyMDIxLTEwLTI1VDIwOjEwOjI5LTA3OjAwIn0sInJlc291cmNlVHlwZSI6IkVuY291bnRlciIsInNlcnZpY2VQcm92aWRlciI6eyJkaXNwbGF5IjoiQ0RFWCBFeGFtcGxlIE9yZ2FuaXphdGlvbiIsInJlZmVyZW5jZSI6InVybjp1dWlkOmUzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhMyJ9LCJzdGF0dXMiOiJmaW5pc2hlZCIsInN1YmplY3QiOnsiZGlzcGxheSI6IkNERVggRXhhbXBsZSBQYXRpZW50IiwicmVmZXJlbmNlIjoidXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlIn0sInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyXCIgPC9wPjwvZGl2PjxwPjxiPnN0YXR1czwvYj46IGZpbmlzaGVkPC9wPjxwPjxiPmNsYXNzPC9iPjogZW1lcmdlbmN5IChEZXRhaWxzOiBodHRwOi8vdGVybWlub2xvZ3kuaGw3Lm9yZy9Db2RlU3lzdGVtL3YzLUFjdENvZGUgY29kZSBFTUVSID0gJ2VtZXJnZW5jeScsIHN0YXRlZCBhcyAnbnVsbCcpPC9wPjxwPjxiPnR5cGU8L2I-OiBVbmtub3duIChxdWFsaWZpZXIgdmFsdWUpIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vYnJvd3Nlci5paHRzZG90b29scy5vcmcvXCI-U05PTUVEIENUPC9hPiMyNjE2NjUwMDYpPC9zcGFuPjwvcD48cD48Yj5zdWJqZWN0PC9iPjogPGEgaHJlZj1cIiNQYXRpZW50Xzk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZVwiPlNlZSBhYm92ZSAodXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlOiBDREVYIEV4YW1wbGUgUGF0aWVudCk8L2E-PC9wPjxoMz5QYXJ0aWNpcGFudHM8L2gzPjx0YWJsZSBjbGFzcz1cImdyaWRcIj48dHI-PHRkPi08L3RkPjx0ZD48Yj5JbmRpdmlkdWFsPC9iPjwvdGQ-PC90cj48dHI-PHRkPio8L3RkPjx0ZD48YSBocmVmPVwiI1ByYWN0aXRpb25lcl8wODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmNcIj5TZWUgYWJvdmUgKHVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYzogSm9obiBIYW5jb2NrKTwvYT48L3RkPjwvdHI-PC90YWJsZT48cD48Yj5wZXJpb2Q8L2I-OiAyMDIxLTEwLTI1VDIwOjEwOjI5LTA3OjAwIC0tJmd0OyAyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwPC9wPjxwPjxiPnNlcnZpY2VQcm92aWRlcjwvYj46IDxhIGhyZWY9XCIjT3JnYW5pemF0aW9uX2UzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhM1wiPlNlZSBhYm92ZSAodXJuOnV1aWQ6ZTM3ZjAwNGItZGMxMC00MjJiLWI4MzMtY2RhYTEwYTA1NWEzOiBDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uKTwvYT48L3A-PC9kaXY-Iiwic3RhdHVzIjoiZ2VuZXJhdGVkIn0sInR5cGUiOlt7ImNvZGluZyI6W3siY29kZSI6IjI2MTY2NTAwNiIsImRpc3BsYXkiOiJVbmtub3duIChxdWFsaWZpZXIgdmFsdWUpIiwic3lzdGVtIjoiaHR0cDovL3Nub21lZC5pbmZvL3NjdCJ9XSwidGV4dCI6IlVua25vd24gKHF1YWxpZmllciB2YWx1ZSkifV19fSx7ImZ1bGxVcmwiOiJ1cm46dXVpZDplMzdmMDA0Yi1kYzEwLTQyMmItYjgzMy1jZGFhMTBhMDU1YTMiLCJyZXNvdXJjZSI6eyJhY3RpdmUiOnRydWUsImFkZHJlc3MiOlt7ImNpdHkiOiJCb3N0b24iLCJjb3VudHJ5IjoiVVNBIiwibGluZSI6WyIxIENERVggTGFuZSJdLCJwb3N0YWxDb2RlIjoiMDEwMDIiLCJzdGF0ZSI6Ik1BIn1dLCJpZCI6ImUzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhMyIsIm5hbWUiOiJDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uIiwicmVzb3VyY2VUeXBlIjoiT3JnYW5pemF0aW9uIiwidGVsZWNvbSI6W3sic3lzdGVtIjoicGhvbmUiLCJ2YWx1ZSI6IigrMSkgNTU1LTU1NS01NTU1In0seyJzeXN0ZW0iOiJlbWFpbCIsInZhbHVlIjoiY3VzdG9tZXItc2VydmljZUBleGFtcGxlLm9yZyJ9XSwidGV4dCI6eyJkaXYiOiI8ZGl2IHhtbG5zPVwiaHR0cDovL3d3dy53My5vcmcvMTk5OS94aHRtbFwiPjxwPjxiPkdlbmVyYXRlZCBOYXJyYXRpdmU8L2I-PC9wPjxkaXYgc3R5bGU9XCJkaXNwbGF5OiBpbmxpbmUtYmxvY2s7IGJhY2tncm91bmQtY29sb3I6ICNkOWUwZTc7IHBhZGRpbmc6IDZweDsgbWFyZ2luOiA0cHg7IGJvcmRlcjogMXB4IHNvbGlkICM4ZGExYjQ7IGJvcmRlci1yYWRpdXM6IDVweDsgbGluZS1oZWlnaHQ6IDYwJVwiPjxwIHN0eWxlPVwibWFyZ2luLWJvdHRvbTogMHB4XCI-UmVzb3VyY2UgXCJlMzdmMDA0Yi1kYzEwLTQyMmItYjgzMy1jZGFhMTBhMDU1YTNcIiA8L3A-PC9kaXY-PHA-PGI-YWN0aXZlPC9iPjogdHJ1ZTwvcD48cD48Yj5uYW1lPC9iPjogQ0RFWCBFeGFtcGxlIE9yZ2FuaXphdGlvbjwvcD48cD48Yj50ZWxlY29tPC9iPjogcGg6ICgrMSkgNTU1LTU1NS01NTU1LCA8YSBocmVmPVwibWFpbHRvOmN1c3RvbWVyLXNlcnZpY2VAZXhhbXBsZS5vcmdcIj5jdXN0b21lci1zZXJ2aWNlQGV4YW1wbGUub3JnPC9hPjwvcD48cD48Yj5hZGRyZXNzPC9iPjogMSBDREVYIExhbmUgQm9zdG9uIE1BIDAxMDAyIFVTQSA8L3A-PC9kaXY-Iiwic3RhdHVzIjoiZ2VuZXJhdGVkIn19fV0sImlkZW50aWZpZXIiOnsic3lzdGVtIjoidXJuOmlldGY6cmZjOjM5ODYiLCJ2YWx1ZSI6InVybjp1dWlkOmMxNzM1MzVlLTEzNWUtNDhlMy1hYjY0LTM4YmFjYzY4ZGJhOCJ9LCJyZXNvdXJjZVR5cGUiOiJCdW5kbGUiLCJ0aW1lc3RhbXAiOiIyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwIiwidHlwZSI6ImRvY3VtZW50In0'
</pre>


**4. Get the base64 encoded JWS  from the `Bundle.signature.data`  element**


```python
recd_b64_jws = recd_signature['data']
recd_b64_jws
```



<pre  style="border:0; background:white; overflow-wrap:break-word;">
    'ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNkltVTJaV1prWWpNMU1HSTJPV0l6TmpsaE5ETmhaVFl3TVRVMFpURTNaak01WVdNM05XVmlOVGdpTENKcmRIa2lPaUpTVXlJc0luTnBaMVFpT2lJeU1ESXdMVEV3TFRJelZEQTBPalUwT2pVMkxqQTBPQ3N3TURvd01DSXNJbk55UTIxeklqcGJleUpqYjIxdFNXUWlPbnNpWkdWell5STZJbFpsY21sbWFXTmhkR2x2YmlCVGFXZHVZWFIxY21VaUxDSnBaQ0k2SW5WeWJqcHZhV1E2TVM0eUxqZzBNQzR4TURBMk5TNHhMakV5TGpFdU5TSjlMQ0pqYjIxdFVYVmhiSE1pT2xzaVZtVnlhV1pwWTJGMGFXOXVJRzltSUcxbFpHbGpZV3dnY21WamIzSmtJR2x1ZEdWbmNtbDBlU0pkZlYwc0luUjVjQ0k2SWtwWFZDSXNJbmcxWXlJNld5Sk5TVWxHWlZSRFEwRXJSMmRCZDBsQ1FXZEpWVTlqUm5GTVQwSnRkRGRXVWpaNU5FWkhiakF3VVZOR1RWaEtaM2RFVVZsS1MyOWFTV2gyWTA1QlVVVk1RbEZCZDJkaFdYaERla0ZLUW1kT1ZrSkJXVlJCYkZaVVRWSlpkMFpCV1VSV1VWRkpSRUV4VGxsWVRucFpWMDV2WkZoT2JHUklVbnBOVVRoM1JGRlpSRlpSVVVoRVFWcERZak5PTUdJeU5IaElWRUZpUW1kT1ZrSkJiMDFHUlZZMFdWY3hkMkpIVldkVU0wcHVXVmMxY0dWdFJqQmhWemwxVFZOSmQwbEJXVVJXVVZGRVJFSnNSRkpGVmxsSlJWWTBXVmN4ZDJKSFZXZFVNMHB1V1ZjMWNHVnRSakJoVnpsMVRWTnpkMHRSV1VwTGIxcEphSFpqVGtGUmEwSkdhSGhxWkZoT01HSXlNV3hqYVRGNldsaEtNbUZYVG14UlIxWTBXVmN4ZDJKSFZYVmlNMHB1VFVJMFdFUlVTVEZOUkdONVRrUkZORTFVVVRCTlJtOVlSRlJKTWsxRVkzaFBWRVUwVFZSUk1FMUdiM2RuWVZsNFEzcEJTa0puVGxaQ1FWbFVRV3hXVkUxU1dYZEdRVmxFVmxGUlNVUkJNVTVaV0U1NldWZE9iMlJZVG14a1NGSjZUVkU0ZDBSUldVUldVVkZJUkVGYVEySXpUakJpTWpSNFNGUkJZa0puVGxaQ1FXOU5Sa1ZXTkZsWE1YZGlSMVZuVkROS2JsbFhOWEJsYlVZd1lWYzVkVTFUU1hkSlFWbEVWbEZSUkVSQ2JFUlNSVlpaU1VWV05GbFhNWGRpUjFWblZETktibGxYTlhCbGJVWXdZVmM1ZFUxVGMzZExVVmxLUzI5YVNXaDJZMDVCVVd0Q1JtaDRhbVJZVGpCaU1qRnNZMmt4ZWxwWVNqSmhWMDVzVVVkV05GbFhNWGRpUjFWMVlqTktiazFKU1VKdmFrRk9RbWRyY1docmFVYzVkekJDUVZGRlJrRkJUME5CV1RoQlRVbEpRbWxuUzBOQldVVkJjblI1U0VsbFJXMXRNVTFwTW1sU04yeFNWemxPVUhoQmVWTTVRbWc0VUhoRk1XSkdTMUJpVW04eFFsZGtSbGx2YzBSQlJFMWplR1JvT1dwMWVXTnphV2hHUlcwdmREbHVZMEpsUW1WTVNURlZkWHBGWWk5TEswWlhNV0ZLYm1acksyRmFla0V5TVhCbk1Yb3djbEpxTjJsVGFIQkxkemhtTUdGcGFIcGhWR2xoUWs5c1UzTmpiMWxFVjJWQ2VUZHdaVFZSTDJWTU4xWlNkWEZuYkZwb1ZtczNXa3hUY0hjNGVHSldWRzlHVUZsNU1rbG9OVFozYldRMGVDdDNORWs1UkZORGMyMXBSVVV4ZDNSWGRWcDBaVlpzWjJWalprMXpXUzlZZW05NlNFSlVhMnMwUm5Kb09GQjRhaTh6YTNaWlZGbFZOVEpxYzJONlFVbE1SR3h3VlVzMFoyRTNXRWROYnpJelVXOTFXR1JHV0ZkSk9FdE5ObGhtVDFKWFEzRlhWU3N5VmpSQ09VMXVhbXBIT0dweVR5dFBRMFJJVVVoS2NVSjRjbXROV1ZjclIydGlhRUp4T0ZsUGJtZFJVVWd2ZEZvNFEybzRkbVl3V2xoRlVXOTFNRXhYYlc5V1RtWmFXWFZ4UTBkRVNqVkpaekJzUVVSdGJTdHNRbmQwVTJWTk9WQndhbkV3WmxaWU5DOTFLeXR2YnpNMlRGbHBibmRPYjBKQmJUTnlVV3hDVGtrMVRWVjNWazl5Y25aUGFHbFhaRmwyV1ZOcU0yWjNRMnRpTVdGTFFtOW1SbkZRVFhJekwyNVRLek5XVDB4blIzQTNkamRoZEVOVVpsZEhOMlo0WmpWRk9IWm9NamQ1TVdweE0wWlFTMUJaTURCeVRuZHpObFl6VVZwMVRsaEJaMDFDUVVGSGFtZGFkM2RuV210M1ExRlpSRlpTTUZSQ1FVbDNRVVJCVEVKblRsWklVVGhGUWtGTlEwSmxRWGRaUVZsRVZsSXdVa0pHYTNkV05FbFFaRE5rTTB4dFZqUlpWekYzWWtkVmRXSXpTbTV2UW10SFExZERSMU5CUjBjclZuTkZRbkZCVFVSQmIzaE5hazB3VGxSWk0wOUVhM3BvYVd4dlpFaFNkMk42YjNaTU1sWTBXVmN4ZDJKSFZYVmlNMHB1VERKYWIyRllTWFpVTTBwdVdWYzFjR1Z0UmpCaFZ6bDFUSHBGZVUxNlFXUkNaMDVXU0ZFMFJVWm5VVlUxZFM5aVRsRjBjSE15Yld0UGRWbENWazlHTDA5aGVERTJNV2QzUkZGWlNrdHZXa2xvZG1OT1FWRkZURUpSUVVSblowZENRVUpwVEU5Vk16bE9SWGxUZWxwVFIzb3lZVTVvWWsxNlZWWTFVbUZVZDNKd1JIaEVkbGxxUkZnemFrVlFMMnB6YldvMEwzQk9LMHcxVWxsQ1dITkNabGw0VTFWMVlsRk1aVloyYTJZMVpuWXJiMGR5YldWRFZ5dG1XRGg1UlRGeWJDdHhPREZEUTB3clVUaE1UMDk2UVZwR2RVVmxXVVU1YVdWamVsazNaazh4T0Uxd1JqaHVRekUwUTBSUllqWkVUakV3VVdGQmRHSm9WRVpoYTFwbFQzRmFZVlZuVkc5RVprbE9jMjQzYW5waEwySndkREZMWlhVMWRsVnpkVEZ4Um1kcVFYQjZRVFlyVFdGc1NVNVZhMGh0WVRKR1N5dDZNbGxtZVRCWEwwNW9kWEJpVEdOWFJXNHhVbmwxVlVKVVVYZHpjMjA1ZDFKUVJFVXZURzlUVlVFemNHMXRjVkJFYkRnM1pEbDBSMFpFU3k5NWJGRlVkV0Z4YkRWMFJqQXliR3A2T0hkWlVXbFRVbVkxYm5wNGNWUnRkRzVOUTIxMmFIbGhlRGMxYmpVd2RHOHZWRzQwYkdndmFqRnBhMjhyZDBOQlYxUk5RMDVyWWl0dE5FY3hiWE5rYjFWWmJrVlpiaTlVYVhwWE9YWkxNMHhvVmxSWE5WcGtTU3QxVm5saGMyUkNhRkpNYjNsc2QxbHBaRlZIUTJGb2RrcG1SRk5IYXpCNFV6YzBhRlZZWWpJeU0wRnRlbWxUUzBVelZFWlFlRk51V2tWMk0zcHBPRzFQYTNwelRWTjFZbXB1Y0VweGNtNVJXRzlDYms1Sk9ITXJhakJKZVZwUk1qbGFiV1E0UTB4TWNXMW5hMGxQVms5MVlXTkRiMnRZZGt0RVYydFZiV3RDZVZKUE5reDNRVDA5SWwxOS4uY0hiVlZWRDhGTjVlOWlWQ1dHUUNPeTlCbHBXS1pSZ3cteEd1WjFOM0pfdjN1Uk5sLUNzZ1piNElMcHFkbldzay1sMHJaUXNmTEI2NENrb2dCb2xobjYtWl9Zazl1d0ZBQmhzR0pWMjk2d2xTTlJsNW5iYXdJUGV1dG5zX2JZMVRLOUpMUFdUWE9iT0lHUEhXR0RnRUFsdk11WWJ1SnR6TXhlRUZlYlN5UHJfZWpvdnB4Ym1HVnh4bzVkcDJ1Nm56SUNzdUNqQjU5NHc0M2k1WWxrMWZDTXEzcVZnbVRRdWRhLWZFV0ZlaVRhWS1vbGc2dnZmN2hva29mR0Vod05hUFA4YWNYOFM2Ykt3OE1nOHVOS3ZSRU00QzJYVGlkaHNuMVYyNWFkU0xKWDZWYTBwNEpfOU1saFRsU2FPdWc1OFVyUVNia1UwZ0stUEQwU01xR0JRWktsdW0yZGdvclhlZkg2NXZBLURCZUtMUVA5LUFvOEtxRTRIbl95Mi1sdVF1bkotMVRQTFo2MGNoNktLazU0OFJCUlk0dUJTdGFIcFpKaGIzRXo5QTZzX0E0YXAxdFhPZV93UnNwWS1mblliY3l0a2FTTjk0NWdDRzQ4Ykh5d2w0Y1JwcV9xdjBNZE9Xd1FlVVhDdFdUcDdTaDU2WS00eDRubWhLWlRUZHhaMEg='
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
<pre  style="border:0; background:white; overflow-wrap:break-word;">
    header:
    eyJhbGciOiJSUzI1NiIsImtpZCI6ImU2ZWZkYjM1MGI2OWIzNjlhNDNhZTYwMTU0ZTE3ZjM5YWM3NWViNTgiLCJrdHkiOiJSUyIsInNpZ1QiOiIyMDIwLTEwLTIzVDA0OjU0OjU2LjA0OCswMDowMCIsInNyQ21zIjpbeyJjb21tSWQiOnsiZGVzYyI6IlZlcmlmaWNhdGlvbiBTaWduYXR1cmUiLCJpZCI6InVybjpvaWQ6MS4yLjg0MC4xMDA2NS4xLjEyLjEuNSJ9LCJjb21tUXVhbHMiOlsiVmVyaWZpY2F0aW9uIG9mIG1lZGljYWwgcmVjb3JkIGludGVncml0eSJdfV0sInR5cCI6IkpXVCIsIng1YyI6WyJNSUlGZVRDQ0ErR2dBd0lCQWdJVU9jRnFMT0JtdDdWUjZ5NEZHbjAwUVNGTVhKZ3dEUVlKS29aSWh2Y05BUUVMQlFBd2dhWXhDekFKQmdOVkJBWVRBbFZUTVJZd0ZBWURWUVFJREExTllYTnpZV05vZFhObGRIUnpNUTh3RFFZRFZRUUhEQVpDYjNOMGIyNHhIVEFiQmdOVkJBb01GRVY0WVcxd2JHVWdUM0puWVc1cGVtRjBhVzl1TVNJd0lBWURWUVFEREJsRFJFVllJRVY0WVcxd2JHVWdUM0puWVc1cGVtRjBhVzl1TVNzd0tRWUpLb1pJaHZjTkFRa0JGaHhqZFhOMGIyMWxjaTF6WlhKMmFXTmxRR1Y0WVcxd2JHVXViM0puTUI0WERUSTFNRGN5TkRFNE1UUTBNRm9YRFRJMk1EY3hPVEU0TVRRME1Gb3dnYVl4Q3pBSkJnTlZCQVlUQWxWVE1SWXdGQVlEVlFRSURBMU5ZWE56WVdOb2RYTmxkSFJ6TVE4d0RRWURWUVFIREFaQ2IzTjBiMjR4SFRBYkJnTlZCQW9NRkVWNFlXMXdiR1VnVDNKbllXNXBlbUYwYVc5dU1TSXdJQVlEVlFRRERCbERSRVZZSUVWNFlXMXdiR1VnVDNKbllXNXBlbUYwYVc5dU1Tc3dLUVlKS29aSWh2Y05BUWtCRmh4amRYTjBiMjFsY2kxelpYSjJhV05sUUdWNFlXMXdiR1V1YjNKbk1JSUJvakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBWThBTUlJQmlnS0NBWUVBcnR5SEllRW1tMU1pMmlSN2xSVzlOUHhBeVM5Qmg4UHhFMWJGS1BiUm8xQldkRllvc0RBRE1jeGRoOWp1eWNzaWhGRW0vdDluY0JlQmVMSTFVdXpFYi9LK0ZXMWFKbmZrK2FaekEyMXBnMXowclJqN2lTaHBLdzhmMGFpaHphVGlhQk9sU3Njb1lEV2VCeTdwZTVRL2VMN1ZSdXFnbFpoVms3WkxTcHc4eGJWVG9GUFl5MkloNTZ3bWQ0eCt3NEk5RFNDc21pRUUxd3RXdVp0ZVZsZ2VjZk1zWS9Yem96SEJUa2s0RnJoOFB4ai8za3ZZVFlVNTJqc2N6QUlMRGxwVUs0Z2E3WEdNbzIzUW91WGRGWFdJOEtNNlhmT1JXQ3FXVSsyVjRCOU1uampHOGpyTytPQ0RIUUhKcUJ4cmtNWVcrR2tiaEJxOFlPbmdRUUgvdFo4Q2o4dmYwWlhFUW91MExXbW9WTmZaWXVxQ0dESjVJZzBsQURtbStsQnd0U2VNOVBwanEwZlZYNC91KytvbzM2TFlpbndOb0JBbTNyUWxCTkk1TVV3Vk9ycnZPaGlXZFl2WVNqM2Z3Q2tiMWFLQm9mRnFQTXIzL25TKzNWT0xnR3A3djdhdENUZldHN2Z4ZjVFOHZoMjd5MWpxM0ZQS1BZMDByTndzNlYzUVp1TlhBZ01CQUFHamdad3dnWmt3Q1FZRFZSMFRCQUl3QURBTEJnTlZIUThFQkFNQ0JlQXdZQVlEVlIwUkJGa3dWNElQZDNkM0xtVjRZVzF3YkdVdWIzSm5vQmtHQ1dDR1NBR0crVnNFQnFBTURBb3hNak0wTlRZM09Ea3poaWxvZEhSd2N6b3ZMMlY0WVcxd2JHVXViM0puTDJab2FYSXZUM0puWVc1cGVtRjBhVzl1THpFeU16QWRCZ05WSFE0RUZnUVU1dS9iTlF0cHMybWtPdVlCVk9GL09heDE2MWd3RFFZSktvWklodmNOQVFFTEJRQURnZ0dCQUJpTE9VMzlORXlTelpTR3oyYU5oYk16VVY1UmFUd3JwRHhEdllqRFgzakVQL2pzbWo0L3BOK0w1UllCWHNCZll4U1V1YlFMZVZ2a2Y1ZnYrb0dybWVDVytmWDh5RTFybCtxODFDQ0wrUThMT096QVpGdUVlWUU5aWVjelk3Zk8xOE1wRjhuQzE0Q0RRYjZETjEwUWFBdGJoVEZha1plT3FaYVVnVG9EZklOc243anphL2JwdDFLZXU1dlVzdTFxRmdqQXB6QTYrTWFsSU5Va0htYTJGSyt6MllmeTBXL05odXBiTGNXRW4xUnl1VUJUUXdzc205d1JQREUvTG9TVUEzcG1tcVBEbDg3ZDl0R0ZESy95bFFUdWFxbDV0RjAybGp6OHdZUWlTUmY1bnp4cVRtdG5NQ212aHlheDc1bjUwdG8vVG40bGgvajFpa28rd0NBV1RNQ05rYittNEcxbXNkb1VZbkVZbi9UaXpXOXZLM0xoVlRXNVpkSSt1Vnlhc2RCaFJMb3lsd1lpZFVHQ2FodkpmRFNHazB4Uzc0aFVYYjIyM0FtemlTS0UzVEZQeFNuWkV2M3ppOG1Pa3pzTVN1YmpucEpxcm5RWG9Cbk5JOHMrajBJeVpRMjlabWQ4Q0xMcW1na0lPVk91YWNDb2tYdktEV2tVbWtCeVJPNkx3QT09Il19
    
    payload:
    
    
    signature:
    cHbVVVD8FN5e9iVCWGQCOy9BlpWKZRgw-xGuZ1N3J_v3uRNl-CsgZb4ILpqdnWsk-l0rZQsfLB64CkogBolhn6-Z_Yk9uwFABhsGJV296wlSNRl5nbawIPeutns_bY1TK9JLPWTXObOIGPHWGDgEAlvMuYbuJtzMxeEFebSyPr_ejovpxbmGVxxo5dp2u6nzICsuCjB594w43i5Ylk1fCMq3qVgmTQuda-fEWFeiTaY-olg6vvf7hokofGEhwNaPP8acX8S6bKw8Mg8uNKvREM4C2XTidhsn1V25adSLJX6Va0p4J_9MlhTlSaOug58UrQSbkU0gK-PD0SMqGBQZKlum2dgorXefH65vA-DBeKLQP9-Ao8KqE4Hn_y2-luQunJ-1TPLZ60ch6KKk548RBRY4uBStaHpZJhb3Ez9A6s_A4ap1tXOe_wRspY-fnYbcytkaSN945gCG48bHywl4cRpq_qv0MdOWwQeUXCtWTp7Sh56Y-4x4nmhKZTTdxZ0H
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
<pre  style="border:0; background:white; overflow-wrap:break-word;">
    header:
    eyJhbGciOiJSUzI1NiIsImtpZCI6ImU2ZWZkYjM1MGI2OWIzNjlhNDNhZTYwMTU0ZTE3ZjM5YWM3NWViNTgiLCJrdHkiOiJSUyIsInNpZ1QiOiIyMDIwLTEwLTIzVDA0OjU0OjU2LjA0OCswMDowMCIsInNyQ21zIjpbeyJjb21tSWQiOnsiZGVzYyI6IlZlcmlmaWNhdGlvbiBTaWduYXR1cmUiLCJpZCI6InVybjpvaWQ6MS4yLjg0MC4xMDA2NS4xLjEyLjEuNSJ9LCJjb21tUXVhbHMiOlsiVmVyaWZpY2F0aW9uIG9mIG1lZGljYWwgcmVjb3JkIGludGVncml0eSJdfV0sInR5cCI6IkpXVCIsIng1YyI6WyJNSUlGZVRDQ0ErR2dBd0lCQWdJVU9jRnFMT0JtdDdWUjZ5NEZHbjAwUVNGTVhKZ3dEUVlKS29aSWh2Y05BUUVMQlFBd2dhWXhDekFKQmdOVkJBWVRBbFZUTVJZd0ZBWURWUVFJREExTllYTnpZV05vZFhObGRIUnpNUTh3RFFZRFZRUUhEQVpDYjNOMGIyNHhIVEFiQmdOVkJBb01GRVY0WVcxd2JHVWdUM0puWVc1cGVtRjBhVzl1TVNJd0lBWURWUVFEREJsRFJFVllJRVY0WVcxd2JHVWdUM0puWVc1cGVtRjBhVzl1TVNzd0tRWUpLb1pJaHZjTkFRa0JGaHhqZFhOMGIyMWxjaTF6WlhKMmFXTmxRR1Y0WVcxd2JHVXViM0puTUI0WERUSTFNRGN5TkRFNE1UUTBNRm9YRFRJMk1EY3hPVEU0TVRRME1Gb3dnYVl4Q3pBSkJnTlZCQVlUQWxWVE1SWXdGQVlEVlFRSURBMU5ZWE56WVdOb2RYTmxkSFJ6TVE4d0RRWURWUVFIREFaQ2IzTjBiMjR4SFRBYkJnTlZCQW9NRkVWNFlXMXdiR1VnVDNKbllXNXBlbUYwYVc5dU1TSXdJQVlEVlFRRERCbERSRVZZSUVWNFlXMXdiR1VnVDNKbllXNXBlbUYwYVc5dU1Tc3dLUVlKS29aSWh2Y05BUWtCRmh4amRYTjBiMjFsY2kxelpYSjJhV05sUUdWNFlXMXdiR1V1YjNKbk1JSUJvakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBWThBTUlJQmlnS0NBWUVBcnR5SEllRW1tMU1pMmlSN2xSVzlOUHhBeVM5Qmg4UHhFMWJGS1BiUm8xQldkRllvc0RBRE1jeGRoOWp1eWNzaWhGRW0vdDluY0JlQmVMSTFVdXpFYi9LK0ZXMWFKbmZrK2FaekEyMXBnMXowclJqN2lTaHBLdzhmMGFpaHphVGlhQk9sU3Njb1lEV2VCeTdwZTVRL2VMN1ZSdXFnbFpoVms3WkxTcHc4eGJWVG9GUFl5MkloNTZ3bWQ0eCt3NEk5RFNDc21pRUUxd3RXdVp0ZVZsZ2VjZk1zWS9Yem96SEJUa2s0RnJoOFB4ai8za3ZZVFlVNTJqc2N6QUlMRGxwVUs0Z2E3WEdNbzIzUW91WGRGWFdJOEtNNlhmT1JXQ3FXVSsyVjRCOU1uampHOGpyTytPQ0RIUUhKcUJ4cmtNWVcrR2tiaEJxOFlPbmdRUUgvdFo4Q2o4dmYwWlhFUW91MExXbW9WTmZaWXVxQ0dESjVJZzBsQURtbStsQnd0U2VNOVBwanEwZlZYNC91KytvbzM2TFlpbndOb0JBbTNyUWxCTkk1TVV3Vk9ycnZPaGlXZFl2WVNqM2Z3Q2tiMWFLQm9mRnFQTXIzL25TKzNWT0xnR3A3djdhdENUZldHN2Z4ZjVFOHZoMjd5MWpxM0ZQS1BZMDByTndzNlYzUVp1TlhBZ01CQUFHamdad3dnWmt3Q1FZRFZSMFRCQUl3QURBTEJnTlZIUThFQkFNQ0JlQXdZQVlEVlIwUkJGa3dWNElQZDNkM0xtVjRZVzF3YkdVdWIzSm5vQmtHQ1dDR1NBR0crVnNFQnFBTURBb3hNak0wTlRZM09Ea3poaWxvZEhSd2N6b3ZMMlY0WVcxd2JHVXViM0puTDJab2FYSXZUM0puWVc1cGVtRjBhVzl1THpFeU16QWRCZ05WSFE0RUZnUVU1dS9iTlF0cHMybWtPdVlCVk9GL09heDE2MWd3RFFZSktvWklodmNOQVFFTEJRQURnZ0dCQUJpTE9VMzlORXlTelpTR3oyYU5oYk16VVY1UmFUd3JwRHhEdllqRFgzakVQL2pzbWo0L3BOK0w1UllCWHNCZll4U1V1YlFMZVZ2a2Y1ZnYrb0dybWVDVytmWDh5RTFybCtxODFDQ0wrUThMT096QVpGdUVlWUU5aWVjelk3Zk8xOE1wRjhuQzE0Q0RRYjZETjEwUWFBdGJoVEZha1plT3FaYVVnVG9EZklOc243anphL2JwdDFLZXU1dlVzdTFxRmdqQXB6QTYrTWFsSU5Va0htYTJGSyt6MllmeTBXL05odXBiTGNXRW4xUnl1VUJUUXdzc205d1JQREUvTG9TVUEzcG1tcVBEbDg3ZDl0R0ZESy95bFFUdWFxbDV0RjAybGp6OHdZUWlTUmY1bnp4cVRtdG5NQ212aHlheDc1bjUwdG8vVG40bGgvajFpa28rd0NBV1RNQ05rYittNEcxbXNkb1VZbkVZbi9UaXpXOXZLM0xoVlRXNVpkSSt1Vnlhc2RCaFJMb3lsd1lpZFVHQ2FodkpmRFNHazB4Uzc0aFVYYjIyM0FtemlTS0UzVEZQeFNuWkV2M3ppOG1Pa3pzTVN1YmpucEpxcm5RWG9Cbk5JOHMrajBJeVpRMjlabWQ4Q0xMcW1na0lPVk91YWNDb2tYdktEV2tVbWtCeVJPNkx3QT09Il19
    
    payload:
    eyJlbnRyeSI6W3siZnVsbFVybCI6InVybjp1dWlkOjE3YTgwYThkLTRjZjEtNGRlYi1hMWZkLTJkYjExMzBlNWY3NiIsInJlc291cmNlIjp7ImF0dGVzdGVyIjpbeyJtb2RlIjoibGVnYWwiLCJwYXJ0eSI6eyJkaXNwbGF5IjoiRXhhbXBsZSBQcmFjdGl0aW9uZXIiLCJyZWZlcmVuY2UiOiJ1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMifSwidGltZSI6IjIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDAifV0sImF1dGhvciI6W3siZGlzcGxheSI6IkV4YW1wbGUgUHJhY3RpdGlvbmVyIiwicmVmZXJlbmNlIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIn1dLCJkYXRlIjoiMjAyMS0xMC0yNVQyMDoxNjoyOS0wNzowMCIsImVuY291bnRlciI6eyJkaXNwbGF5IjoiRXhhbXBsZSBFbmNvdW50ZXIiLCJyZWZlcmVuY2UiOiJ1cm46dXVpZDo1Y2U1YzgzYS0wMDBmLTQ3ZDItOTQxYy0wMzkzNThjYzkxMTIifSwiaWQiOiIxN2E4MGE4ZC00Y2YxLTRkZWItYTFmZC0yZGIxMTMwZTVmNzYiLCJyZXNvdXJjZVR5cGUiOiJDb21wb3NpdGlvbiIsInNlY3Rpb24iOlt7ImVudHJ5IjpbeyJyZWZlcmVuY2UiOiJ1cm46dXVpZDowMTRhNjhlYy1kNjkxLTQ5ZTAtYjk4MC05MWIwZDkyNGU1NzAifV0sInRpdGxlIjoiQWN0aXZlIENvbmRpdGlvbiAxIn1dLCJzdGF0dXMiOiJmaW5hbCIsInN1YmplY3QiOnsiZGlzcGxheSI6IkV4YW1wbGUgUGF0aWVudCIsInJlZmVyZW5jZSI6InVybjp1dWlkOjk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZSJ9LCJ0ZXh0Ijp7ImRpdiI6IjxkaXYgeG1sbnM9XCJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hodG1sXCI-PHA-PGI-R2VuZXJhdGVkIE5hcnJhdGl2ZTwvYj48L3A-PGRpdiBzdHlsZT1cImRpc3BsYXk6IGlubGluZS1ibG9jazsgYmFja2dyb3VuZC1jb2xvcjogI2Q5ZTBlNzsgcGFkZGluZzogNnB4OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQgIzhkYTFiNDsgYm9yZGVyLXJhZGl1czogNXB4OyBsaW5lLWhlaWdodDogNjAlXCI-PHAgc3R5bGU9XCJtYXJnaW4tYm90dG9tOiAwcHhcIj5SZXNvdXJjZSBcIjE3YTgwYThkLTRjZjEtNGRlYi1hMWZkLTJkYjExMzBlNWY3NlwiIDwvcD48L2Rpdj48cD48Yj5zdGF0dXM8L2I-OiBmaW5hbDwvcD48cD48Yj50eXBlPC9iPjogTWVkaWNhbCByZWNvcmRzIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vbG9pbmMub3JnL1wiPkxPSU5DPC9hPiMxMTUwMy0wKTwvc3Bhbj48L3A-PHA-PGI-ZW5jb3VudGVyPC9iPjogPGEgaHJlZj1cIiNFbmNvdW50ZXJfNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyXCI-U2VlIGFib3ZlICh1cm46dXVpZDo1Y2U1YzgzYS0wMDBmLTQ3ZDItOTQxYy0wMzkzNThjYzkxMTI6IEV4YW1wbGUgRW5jb3VudGVyKTwvYT48L3A-PHA-PGI-ZGF0ZTwvYj46IDIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDA8L3A-PHA-PGI-YXV0aG9yPC9iPjogPGEgaHJlZj1cIiNQcmFjdGl0aW9uZXJfMDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjXCI-U2VlIGFib3ZlICh1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmM6IEV4YW1wbGUgUHJhY3RpdGlvbmVyKTwvYT48L3A-PHA-PGI-dGl0bGU8L2I-OiBBY3RpdmUgQ29uZGl0aW9uczwvcD48aDM-QXR0ZXN0ZXJzPC9oMz48dGFibGUgY2xhc3M9XCJncmlkXCI-PHRyPjx0ZD4tPC90ZD48dGQ-PGI-TW9kZTwvYj48L3RkPjx0ZD48Yj5UaW1lPC9iPjwvdGQ-PHRkPjxiPlBhcnR5PC9iPjwvdGQ-PC90cj48dHI-PHRkPio8L3RkPjx0ZD5sZWdhbDwvdGQ-PHRkPjIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDA8L3RkPjx0ZD48YSBocmVmPVwiI1ByYWN0aXRpb25lcl8wODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmNcIj5TZWUgYWJvdmUgKHVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYzogRXhhbXBsZSBQcmFjdGl0aW9uZXIpPC9hPjwvdGQ-PC90cj48L3RhYmxlPjwvZGl2PiIsInN0YXR1cyI6ImdlbmVyYXRlZCJ9LCJ0aXRsZSI6IkFjdGl2ZSBDb25kaXRpb25zIiwidHlwZSI6eyJjb2RpbmciOlt7ImNvZGUiOiIxMTUwMy0wIiwic3lzdGVtIjoiaHR0cDovL2xvaW5jLm9yZyJ9XSwidGV4dCI6Ik1lZGljYWwgcmVjb3JkcyJ9fX0seyJmdWxsVXJsIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIiwicmVzb3VyY2UiOnsiaWQiOiIwODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMiLCJtZXRhIjp7Imxhc3RVcGRhdGVkIjoiMjAxMy0wNS0wNVQxNjoxMzowM1oifSwibmFtZSI6W3siZmFtaWx5IjoiSGFuY29jayIsImdpdmVuIjpbIkpvaG4iXX1dLCJyZXNvdXJjZVR5cGUiOiJQcmFjdGl0aW9uZXIiLCJ0ZXh0Ijp7ImRpdiI6IjxkaXYgeG1sbnM9XCJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hodG1sXCI-PHA-PGI-R2VuZXJhdGVkIE5hcnJhdGl2ZTwvYj48L3A-PGRpdiBzdHlsZT1cImRpc3BsYXk6IGlubGluZS1ibG9jazsgYmFja2dyb3VuZC1jb2xvcjogI2Q5ZTBlNzsgcGFkZGluZzogNnB4OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQgIzhkYTFiNDsgYm9yZGVyLXJhZGl1czogNXB4OyBsaW5lLWhlaWdodDogNjAlXCI-PHAgc3R5bGU9XCJtYXJnaW4tYm90dG9tOiAwcHhcIj5SZXNvdXJjZSBcIjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliY1wiIFVwZGF0ZWQgXCIyMDEzLTA1LTA1VDE2OjEzOjAzWlwiIDwvcD48L2Rpdj48cD48Yj5uYW1lPC9iPjogSm9obiBIYW5jb2NrIDwvcD48L2Rpdj4iLCJzdGF0dXMiOiJnZW5lcmF0ZWQifX19LHsiZnVsbFVybCI6InVybjp1dWlkOjk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZSIsInJlc291cmNlIjp7ImFjdGl2ZSI6dHJ1ZSwiaWQiOiI5NzBhZjZjOS01YmJkLTQwNjctYjZjMS1kOWIyYzgyM2FlY2UiLCJuYW1lIjpbeyJmYW1pbHkiOiJQYXRpZW50IiwiZ2l2ZW4iOlsiQ0RFWCBFeGFtcGxlIl0sInRleHQiOiJDREVYIEV4YW1wbGUgUGF0aWVudCJ9XSwicmVzb3VyY2VUeXBlIjoiUGF0aWVudCIsInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiOTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlXCIgPC9wPjwvZGl2PjxwPjxiPmFjdGl2ZTwvYj46IHRydWU8L3A-PHA-PGI-bmFtZTwvYj46IENERVggRXhhbXBsZSBQYXRpZW50PC9wPjwvZGl2PiIsInN0YXR1cyI6ImdlbmVyYXRlZCJ9fX0seyJmdWxsVXJsIjoidXJuOnV1aWQ6MDE0YTY4ZWMtZDY5MS00OWUwLWI5ODAtOTFiMGQ5MjRlNTcwIiwicmVzb3VyY2UiOnsiYXNzZXJ0ZXIiOnsicmVmZXJlbmNlIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIn0sImNhdGVnb3J5IjpbeyJjb2RpbmciOlt7ImNvZGUiOiI1NTYwNzAwNiIsImRpc3BsYXkiOiJQcm9ibGVtIiwic3lzdGVtIjoiaHR0cDovL3Nub21lZC5pbmZvL3NjdCJ9LHsiY29kZSI6Ijc1MzI2LTkiLCJkaXNwbGF5IjoiUHJvYmxlbSIsInN5c3RlbSI6Imh0dHA6Ly9sb2luYy5vcmcifV19XSwiY2xpbmljYWxTdGF0dXMiOnsiY29kaW5nIjpbeyJjb2RlIjoiYWN0aXZlIiwic3lzdGVtIjoiaHR0cDovL3Rlcm1pbm9sb2d5LmhsNy5vcmcvQ29kZVN5c3RlbS9jb25kaXRpb24tY2xpbmljYWwifV19LCJjb2RlIjp7ImNvZGluZyI6W3siY29kZSI6IjQ0MDU0MDA2IiwiZGlzcGxheSI6IlR5cGUgMiBEaWFiZXRlcyBNZWxsaXR1cyIsInN5c3RlbSI6Imh0dHA6Ly9zbm9tZWQuaW5mby9zY3QifV19LCJpZCI6IjAxNGE2OGVjLWQ2OTEtNDllMC1iOTgwLTkxYjBkOTI0ZTU3MCIsImlkZW50aWZpZXIiOlt7InN5c3RlbSI6InVybjpvaWQ6MS4zLjYuMS40LjEuMjI4MTIuNC4xMTEuMC40LjEuMi4xIiwidmFsdWUiOiIxIn1dLCJvbnNldERhdGVUaW1lIjoiMjAwNiIsInJlc291cmNlVHlwZSI6IkNvbmRpdGlvbiIsInN1YmplY3QiOnsicmVmZXJlbmNlIjoidXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlIn0sInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiMDE0YTY4ZWMtZDY5MS00OWUwLWI5ODAtOTFiMGQ5MjRlNTcwXCIgPC9wPjwvZGl2PjxwPjxiPmlkZW50aWZpZXI8L2I-OiBpZDogMTwvcD48cD48Yj5jbGluaWNhbFN0YXR1czwvYj46IEFjdGl2ZSA8c3BhbiBzdHlsZT1cImJhY2tncm91bmQ6IExpZ2h0R29sZGVuUm9kWWVsbG93OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQga2hha2lcIj4gKDxhIGhyZWY9XCJodHRwOi8vdGVybWlub2xvZ3kuaGw3Lm9yZy8zLjAuMC9Db2RlU3lzdGVtLWNvbmRpdGlvbi1jbGluaWNhbC5odG1sXCI-Q29uZGl0aW9uIENsaW5pY2FsIFN0YXR1cyBDb2RlczwvYT4jYWN0aXZlKTwvc3Bhbj48L3A-PHA-PGI-Y2F0ZWdvcnk8L2I-OiBQcm9ibGVtIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vYnJvd3Nlci5paHRzZG90b29scy5vcmcvXCI-U05PTUVEIENUPC9hPiM1NTYwNzAwNjsgPGEgaHJlZj1cImh0dHBzOi8vbG9pbmMub3JnL1wiPkxPSU5DPC9hPiM3NTMyNi05KTwvc3Bhbj48L3A-PHA-PGI-Y29kZTwvYj46IFR5cGUgMiBEaWFiZXRlcyBNZWxsaXR1cyA8c3BhbiBzdHlsZT1cImJhY2tncm91bmQ6IExpZ2h0R29sZGVuUm9kWWVsbG93OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQga2hha2lcIj4gKDxhIGhyZWY9XCJodHRwczovL2Jyb3dzZXIuaWh0c2RvdG9vbHMub3JnL1wiPlNOT01FRCBDVDwvYT4jNDQwNTQwMDYpPC9zcGFuPjwvcD48cD48Yj5zdWJqZWN0PC9iPjogPGEgaHJlZj1cIiNQYXRpZW50Xzk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZVwiPlNlZSBhYm92ZSAodXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlKTwvYT48L3A-PHA-PGI-b25zZXQ8L2I-OiAyMDA2LTAxLTAxPC9wPjxwPjxiPmFzc2VydGVyPC9iPjogPGEgaHJlZj1cIiNQcmFjdGl0aW9uZXJfMDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjXCI-U2VlIGFib3ZlICh1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMpPC9hPjwvcD48L2Rpdj4iLCJzdGF0dXMiOiJnZW5lcmF0ZWQifX19LHsiZnVsbFVybCI6InVybjp1dWlkOjVjZTVjODNhLTAwMGYtNDdkMi05NDFjLTAzOTM1OGNjOTExMiIsInJlc291cmNlIjp7ImNsYXNzIjp7ImNvZGUiOiJFTUVSIiwic3lzdGVtIjoiaHR0cDovL3Rlcm1pbm9sb2d5LmhsNy5vcmcvQ29kZVN5c3RlbS92My1BY3RDb2RlIn0sImlkIjoiNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyIiwicGFydGljaXBhbnQiOlt7ImluZGl2aWR1YWwiOnsiZGlzcGxheSI6IkpvaG4gSGFuY29jayIsInJlZmVyZW5jZSI6InVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYyJ9fV0sInBlcmlvZCI6eyJlbmQiOiIyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwIiwic3RhcnQiOiIyMDIxLTEwLTI1VDIwOjEwOjI5LTA3OjAwIn0sInJlc291cmNlVHlwZSI6IkVuY291bnRlciIsInNlcnZpY2VQcm92aWRlciI6eyJkaXNwbGF5IjoiQ0RFWCBFeGFtcGxlIE9yZ2FuaXphdGlvbiIsInJlZmVyZW5jZSI6InVybjp1dWlkOmUzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhMyJ9LCJzdGF0dXMiOiJmaW5pc2hlZCIsInN1YmplY3QiOnsiZGlzcGxheSI6IkNERVggRXhhbXBsZSBQYXRpZW50IiwicmVmZXJlbmNlIjoidXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlIn0sInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyXCIgPC9wPjwvZGl2PjxwPjxiPnN0YXR1czwvYj46IGZpbmlzaGVkPC9wPjxwPjxiPmNsYXNzPC9iPjogZW1lcmdlbmN5IChEZXRhaWxzOiBodHRwOi8vdGVybWlub2xvZ3kuaGw3Lm9yZy9Db2RlU3lzdGVtL3YzLUFjdENvZGUgY29kZSBFTUVSID0gJ2VtZXJnZW5jeScsIHN0YXRlZCBhcyAnbnVsbCcpPC9wPjxwPjxiPnR5cGU8L2I-OiBVbmtub3duIChxdWFsaWZpZXIgdmFsdWUpIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vYnJvd3Nlci5paHRzZG90b29scy5vcmcvXCI-U05PTUVEIENUPC9hPiMyNjE2NjUwMDYpPC9zcGFuPjwvcD48cD48Yj5zdWJqZWN0PC9iPjogPGEgaHJlZj1cIiNQYXRpZW50Xzk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZVwiPlNlZSBhYm92ZSAodXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlOiBDREVYIEV4YW1wbGUgUGF0aWVudCk8L2E-PC9wPjxoMz5QYXJ0aWNpcGFudHM8L2gzPjx0YWJsZSBjbGFzcz1cImdyaWRcIj48dHI-PHRkPi08L3RkPjx0ZD48Yj5JbmRpdmlkdWFsPC9iPjwvdGQ-PC90cj48dHI-PHRkPio8L3RkPjx0ZD48YSBocmVmPVwiI1ByYWN0aXRpb25lcl8wODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmNcIj5TZWUgYWJvdmUgKHVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYzogSm9obiBIYW5jb2NrKTwvYT48L3RkPjwvdHI-PC90YWJsZT48cD48Yj5wZXJpb2Q8L2I-OiAyMDIxLTEwLTI1VDIwOjEwOjI5LTA3OjAwIC0tJmd0OyAyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwPC9wPjxwPjxiPnNlcnZpY2VQcm92aWRlcjwvYj46IDxhIGhyZWY9XCIjT3JnYW5pemF0aW9uX2UzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhM1wiPlNlZSBhYm92ZSAodXJuOnV1aWQ6ZTM3ZjAwNGItZGMxMC00MjJiLWI4MzMtY2RhYTEwYTA1NWEzOiBDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uKTwvYT48L3A-PC9kaXY-Iiwic3RhdHVzIjoiZ2VuZXJhdGVkIn0sInR5cGUiOlt7ImNvZGluZyI6W3siY29kZSI6IjI2MTY2NTAwNiIsImRpc3BsYXkiOiJVbmtub3duIChxdWFsaWZpZXIgdmFsdWUpIiwic3lzdGVtIjoiaHR0cDovL3Nub21lZC5pbmZvL3NjdCJ9XSwidGV4dCI6IlVua25vd24gKHF1YWxpZmllciB2YWx1ZSkifV19fSx7ImZ1bGxVcmwiOiJ1cm46dXVpZDplMzdmMDA0Yi1kYzEwLTQyMmItYjgzMy1jZGFhMTBhMDU1YTMiLCJyZXNvdXJjZSI6eyJhY3RpdmUiOnRydWUsImFkZHJlc3MiOlt7ImNpdHkiOiJCb3N0b24iLCJjb3VudHJ5IjoiVVNBIiwibGluZSI6WyIxIENERVggTGFuZSJdLCJwb3N0YWxDb2RlIjoiMDEwMDIiLCJzdGF0ZSI6Ik1BIn1dLCJpZCI6ImUzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhMyIsIm5hbWUiOiJDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uIiwicmVzb3VyY2VUeXBlIjoiT3JnYW5pemF0aW9uIiwidGVsZWNvbSI6W3sic3lzdGVtIjoicGhvbmUiLCJ2YWx1ZSI6IigrMSkgNTU1LTU1NS01NTU1In0seyJzeXN0ZW0iOiJlbWFpbCIsInZhbHVlIjoiY3VzdG9tZXItc2VydmljZUBleGFtcGxlLm9yZyJ9XSwidGV4dCI6eyJkaXYiOiI8ZGl2IHhtbG5zPVwiaHR0cDovL3d3dy53My5vcmcvMTk5OS94aHRtbFwiPjxwPjxiPkdlbmVyYXRlZCBOYXJyYXRpdmU8L2I-PC9wPjxkaXYgc3R5bGU9XCJkaXNwbGF5OiBpbmxpbmUtYmxvY2s7IGJhY2tncm91bmQtY29sb3I6ICNkOWUwZTc7IHBhZGRpbmc6IDZweDsgbWFyZ2luOiA0cHg7IGJvcmRlcjogMXB4IHNvbGlkICM4ZGExYjQ7IGJvcmRlci1yYWRpdXM6IDVweDsgbGluZS1oZWlnaHQ6IDYwJVwiPjxwIHN0eWxlPVwibWFyZ2luLWJvdHRvbTogMHB4XCI-UmVzb3VyY2UgXCJlMzdmMDA0Yi1kYzEwLTQyMmItYjgzMy1jZGFhMTBhMDU1YTNcIiA8L3A-PC9kaXY-PHA-PGI-YWN0aXZlPC9iPjogdHJ1ZTwvcD48cD48Yj5uYW1lPC9iPjogQ0RFWCBFeGFtcGxlIE9yZ2FuaXphdGlvbjwvcD48cD48Yj50ZWxlY29tPC9iPjogcGg6ICgrMSkgNTU1LTU1NS01NTU1LCA8YSBocmVmPVwibWFpbHRvOmN1c3RvbWVyLXNlcnZpY2VAZXhhbXBsZS5vcmdcIj5jdXN0b21lci1zZXJ2aWNlQGV4YW1wbGUub3JnPC9hPjwvcD48cD48Yj5hZGRyZXNzPC9iPjogMSBDREVYIExhbmUgQm9zdG9uIE1BIDAxMDAyIFVTQSA8L3A-PC9kaXY-Iiwic3RhdHVzIjoiZ2VuZXJhdGVkIn19fV0sImlkZW50aWZpZXIiOnsic3lzdGVtIjoidXJuOmlldGY6cmZjOjM5ODYiLCJ2YWx1ZSI6InVybjp1dWlkOmMxNzM1MzVlLTEzNWUtNDhlMy1hYjY0LTM4YmFjYzY4ZGJhOCJ9LCJyZXNvdXJjZVR5cGUiOiJCdW5kbGUiLCJ0aW1lc3RhbXAiOiIyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwIiwidHlwZSI6ImRvY3VtZW50In0
    
    signature:
    cHbVVVD8FN5e9iVCWGQCOy9BlpWKZRgw-xGuZ1N3J_v3uRNl-CsgZb4ILpqdnWsk-l0rZQsfLB64CkogBolhn6-Z_Yk9uwFABhsGJV296wlSNRl5nbawIPeutns_bY1TK9JLPWTXObOIGPHWGDgEAlvMuYbuJtzMxeEFebSyPr_ejovpxbmGVxxo5dp2u6nzICsuCjB594w43i5Ylk1fCMq3qVgmTQuda-fEWFeiTaY-olg6vvf7hokofGEhwNaPP8acX8S6bKw8Mg8uNKvREM4C2XTidhsn1V25adSLJX6Va0p4J_9MlhTlSaOug58UrQSbkU0gK-PD0SMqGBQZKlum2dgorXefH65vA-DBeKLQP9-Ao8KqE4Hn_y2-luQunJ-1TPLZ60ch6KKk548RBRY4uBStaHpZJhb3Ez9A6s_A4ap1tXOe_wRspY-fnYbcytkaSN945gCG48bHywl4cRpq_qv0MdOWwQeUXCtWTp7Sh56Y-4x4nmhKZTTdxZ0H
</pre>


**7. Obtain public Key from the first certificate in JWS header `"x5c"` key**

- base64 decode the key value
- Verify (Not shown)
  - Issuer
  - Vaiditity dates of Signature
  - The `Signature.type.code` elements SHALL contain the same values as the "srCms" header ids.
  - The `Signature.when` SHALL match the "Sigt" header timestamp
  - The `Signature.who` SHALL match the "srCms" Signer Commitments header id.,
- Get the “Subject Public Key Info” from the cert to verify the signature


```python
recd_header = jws.get_unverified_header(recd_jws)
recd_header
```



<pre  style="border:0; background:white; overflow-wrap:break-word;">
    {'alg': 'RS256',
     'kid': 'e6efdb350b69b369a43ae60154e17f39ac75eb58',
     'kty': 'RS',
     'sigT': '2020-10-23T04:54:56.048+00:00',
     'srCms': [{'commId': {'desc': 'Verification Signature',
        'id': 'urn:oid:1.2.840.10065.1.12.1.5'},
       'commQuals': ['Verification of medical record integrity']}],
     'typ': 'JWT',
     'x5c': ['MIIFeTCCA+GgAwIBAgIUOcFqLOBmt7VR6y4FGn00QSFMXJgwDQYJKoZIhvcNAQELBQAwgaYxCzAJBgNVBAYTAlVTMRYwFAYDVQQIDA1NYXNzYWNodXNldHRzMQ8wDQYDVQQHDAZCb3N0b24xHTAbBgNVBAoMFEV4YW1wbGUgT3JnYW5pemF0aW9uMSIwIAYDVQQDDBlDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uMSswKQYJKoZIhvcNAQkBFhxjdXN0b21lci1zZXJ2aWNlQGV4YW1wbGUub3JnMB4XDTI1MDcyNDE4MTQ0MFoXDTI2MDcxOTE4MTQ0MFowgaYxCzAJBgNVBAYTAlVTMRYwFAYDVQQIDA1NYXNzYWNodXNldHRzMQ8wDQYDVQQHDAZCb3N0b24xHTAbBgNVBAoMFEV4YW1wbGUgT3JnYW5pemF0aW9uMSIwIAYDVQQDDBlDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uMSswKQYJKoZIhvcNAQkBFhxjdXN0b21lci1zZXJ2aWNlQGV4YW1wbGUub3JnMIIBojANBgkqhkiG9w0BAQEFAAOCAY8AMIIBigKCAYEArtyHIeEmm1Mi2iR7lRW9NPxAyS9Bh8PxE1bFKPbRo1BWdFYosDADMcxdh9juycsihFEm/t9ncBeBeLI1UuzEb/K+FW1aJnfk+aZzA21pg1z0rRj7iShpKw8f0aihzaTiaBOlSscoYDWeBy7pe5Q/eL7VRuqglZhVk7ZLSpw8xbVToFPYy2Ih56wmd4x+w4I9DSCsmiEE1wtWuZteVlgecfMsY/XzozHBTkk4Frh8Pxj/3kvYTYU52jsczAILDlpUK4ga7XGMo23QouXdFXWI8KM6XfORWCqWU+2V4B9MnjjG8jrO+OCDHQHJqBxrkMYW+GkbhBq8YOngQQH/tZ8Cj8vf0ZXEQou0LWmoVNfZYuqCGDJ5Ig0lADmm+lBwtSeM9Ppjq0fVX4/u++oo36LYinwNoBAm3rQlBNI5MUwVOrrvOhiWdYvYSj3fwCkb1aKBofFqPMr3/nS+3VOLgGp7v7atCTfWG7fxf5E8vh27y1jq3FPKPY00rNws6V3QZuNXAgMBAAGjgZwwgZkwCQYDVR0TBAIwADALBgNVHQ8EBAMCBeAwYAYDVR0RBFkwV4IPd3d3LmV4YW1wbGUub3JnoBkGCWCGSAGG+VsEBqAMDAoxMjM0NTY3ODkzhilodHRwczovL2V4YW1wbGUub3JnL2ZoaXIvT3JnYW5pemF0aW9uLzEyMzAdBgNVHQ4EFgQU5u/bNQtps2mkOuYBVOF/Oax161gwDQYJKoZIhvcNAQELBQADggGBABiLOU39NEySzZSGz2aNhbMzUV5RaTwrpDxDvYjDX3jEP/jsmj4/pN+L5RYBXsBfYxSUubQLeVvkf5fv+oGrmeCW+fX8yE1rl+q81CCL+Q8LOOzAZFuEeYE9ieczY7fO18MpF8nC14CDQb6DN10QaAtbhTFakZeOqZaUgToDfINsn7jza/bpt1Keu5vUsu1qFgjApzA6+MalINUkHma2FK+z2Yfy0W/NhupbLcWEn1RyuUBTQwssm9wRPDE/LoSUA3pmmqPDl87d9tGFDK/ylQTuaql5tF02ljz8wYQiSRf5nzxqTmtnMCmvhyax75n50to/Tn4lh/j1iko+wCAWTMCNkb+m4G1msdoUYnEYn/TizW9vK3LhVTW5ZdI+uVyasdBhRLoylwYidUGCahvJfDSGk0xS74hUXb223AmziSKE3TFPxSnZEv3zi8mOkzsMSubjnpJqrnQXoBnNI8s+j0IyZQ29Zmd8CLLqmgkIOVOuacCokXvKDWkUmkByRO6LwA==']}
</pre>



```python
recd_cert = b64decode(recd_header['x5c'][0])
with open('recd_cert.der', 'wb') as f:
    f.write(recd_cert)
!openssl x509 -in recd_cert.der -inform DER -text
```


<pre  style="border:0; background:white; overflow-wrap:break-word;">
    Certificate:
        Data:
            Version: 3 (0x2)
            Serial Number:
                39:c1:6a:2c:e0:66:b7:b5:51:eb:2e:05:1a:7d:34:41:21:4c:5c:98
            Signature Algorithm: sha256WithRSAEncryption
            Issuer: C=US, ST=Massachusetts, L=Boston, O=Example Organization, CN=CDEX Example Organization, emailAddress=customer-service@example.org
            Validity
                Not Before: Jul 24 18:14:40 2025 GMT
                Not After : Jul 19 18:14:40 2026 GMT
            Subject: C=US, ST=Massachusetts, L=Boston, O=Example Organization, CN=CDEX Example Organization, emailAddress=customer-service@example.org
            Subject Public Key Info:
                Public Key Algorithm: rsaEncryption
                    Public-Key: (3072 bit)
                    Modulus:
                        00:ae:dc:87:21:e1:26:9b:53:22:da:24:7b:95:15:
                        bd:34:fc:40:c9:2f:41:87:c3:f1:13:56:c5:28:f6:
                        d1:a3:50:56:74:56:28:b0:30:03:31:cc:5d:87:d8:
                        ee:c9:cb:22:84:51:26:fe:df:67:70:17:81:78:b2:
                        35:52:ec:c4:6f:f2:be:15:6d:5a:26:77:e4:f9:a6:
                        73:03:6d:69:83:5c:f4:ad:18:fb:89:28:69:2b:0f:
                        1f:d1:a8:a1:cd:a4:e2:68:13:a5:4a:c7:28:60:35:
                        9e:07:2e:e9:7b:94:3f:78:be:d5:46:ea:a0:95:98:
                        55:93:b6:4b:4a:9c:3c:c5:b5:53:a0:53:d8:cb:62:
                        21:e7:ac:26:77:8c:7e:c3:82:3d:0d:20:ac:9a:21:
                        04:d7:0b:56:b9:9b:5e:56:58:1e:71:f3:2c:63:f5:
                        f3:a3:31:c1:4e:49:38:16:b8:7c:3f:18:ff:de:4b:
                        d8:4d:85:39:da:3b:1c:cc:02:0b:0e:5a:54:2b:88:
                        1a:ed:71:8c:a3:6d:d0:a2:e5:dd:15:75:88:f0:a3:
                        3a:5d:f3:91:58:2a:96:53:ed:95:e0:1f:4c:9e:38:
                        c6:f2:3a:ce:f8:e0:83:1d:01:c9:a8:1c:6b:90:c6:
                        16:f8:69:1b:84:1a:bc:60:e9:e0:41:01:ff:b5:9f:
                        02:8f:cb:df:d1:95:c4:42:8b:b4:2d:69:a8:54:d7:
                        d9:62:ea:82:18:32:79:22:0d:25:00:39:a6:fa:50:
                        70:b5:27:8c:f4:fa:63:ab:47:d5:5f:8f:ee:fb:ea:
                        28:df:a2:d8:8a:7c:0d:a0:10:26:de:b4:25:04:d2:
                        39:31:4c:15:3a:ba:ef:3a:18:96:75:8b:d8:4a:3d:
                        df:c0:29:1b:d5:a2:81:a1:f1:6a:3c:ca:f7:fe:74:
                        be:dd:53:8b:80:6a:7b:bf:b6:ad:09:37:d6:1b:b7:
                        f1:7f:91:3c:be:1d:bb:cb:58:ea:dc:53:ca:3d:8d:
                        34:ac:dc:2c:e9:5d:d0:66:e3:57
                    Exponent: 65537 (0x10001)
            X509v3 extensions:
                X509v3 Basic Constraints: 
                    CA:FALSE
                X509v3 Key Usage: 
                    Digital Signature, Non Repudiation, Key Encipherment
                X509v3 Subject Alternative Name: 
                    DNS:www.example.org, othername: 2.16.840.1.113883.4.6:1234567893, URI:https://example.org/fhir/Organization/123
                X509v3 Subject Key Identifier: 
                    E6:EF:DB:35:0B:69:B3:69:A4:3A:E6:01:54:E1:7F:39:AC:75:EB:58
        Signature Algorithm: sha256WithRSAEncryption
        Signature Value:
            18:8b:39:4d:fd:34:4c:92:cd:94:86:cf:66:8d:85:b3:33:51:
            5e:51:69:3c:2b:a4:3c:43:bd:88:c3:5f:78:c4:3f:f8:ec:9a:
            3e:3f:a4:df:8b:e5:16:01:5e:c0:5f:63:14:94:b9:b4:0b:79:
            5b:e4:7f:97:ef:fa:81:ab:99:e0:96:f9:f5:fc:c8:4d:6b:97:
            ea:bc:d4:20:8b:f9:0f:0b:38:ec:c0:64:5b:84:79:81:3d:89:
            e7:33:63:b7:ce:d7:c3:29:17:c9:c2:d7:80:83:41:be:83:37:
            5d:10:68:0b:5b:85:31:5a:91:97:8e:a9:96:94:81:3a:03:7c:
            83:6c:9f:b8:f3:6b:f6:e9:b7:52:9e:bb:9b:d4:b2:ed:6a:16:
            08:c0:a7:30:3a:f8:c6:a5:20:d5:24:1e:66:b6:14:af:b3:d9:
            87:f2:d1:6f:cd:86:ea:5b:2d:c5:84:9f:54:72:b9:40:53:43:
            0b:2c:9b:dc:11:3c:31:3f:2e:84:94:03:7a:66:9a:a3:c3:97:
            ce:dd:f6:d1:85:0c:af:f2:95:04:ee:6a:a9:79:b4:5d:36:96:
            3c:fc:c1:84:22:49:17:f9:9f:3c:6a:4e:6b:67:30:29:af:87:
            26:b1:ef:99:f9:d2:da:3f:4e:7e:25:87:f8:f5:8a:4a:3e:c0:
            20:16:4c:c0:8d:91:bf:a6:e0:6d:66:b1:da:14:62:71:18:9f:
            f4:e2:cd:6f:6f:2b:72:e1:55:35:b9:65:d2:3e:b9:5c:9a:b1:
            d0:61:44:ba:32:97:06:22:75:41:82:6a:1b:c9:7c:34:86:93:
            4c:52:ef:88:54:5d:bd:b6:dc:09:b3:89:22:84:dd:31:4f:c5:
            29:d9:12:fd:f3:8b:c9:8e:93:3b:0c:4a:e6:e3:9e:92:6a:ae:
            74:17:a0:19:cd:23:cb:3e:8f:42:32:65:0d:bd:66:67:7c:08:
            b2:ea:9a:09:08:39:53:ae:69:c0:a8:91:7b:ca:0d:69:14:9a:
            40:72:44:ee:8b:c0
    -----BEGIN CERTIFICATE-----
    MIIFeTCCA+GgAwIBAgIUOcFqLOBmt7VR6y4FGn00QSFMXJgwDQYJKoZIhvcNAQEL
    BQAwgaYxCzAJBgNVBAYTAlVTMRYwFAYDVQQIDA1NYXNzYWNodXNldHRzMQ8wDQYD
    VQQHDAZCb3N0b24xHTAbBgNVBAoMFEV4YW1wbGUgT3JnYW5pemF0aW9uMSIwIAYD
    VQQDDBlDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uMSswKQYJKoZIhvcNAQkBFhxj
    dXN0b21lci1zZXJ2aWNlQGV4YW1wbGUub3JnMB4XDTI1MDcyNDE4MTQ0MFoXDTI2
    MDcxOTE4MTQ0MFowgaYxCzAJBgNVBAYTAlVTMRYwFAYDVQQIDA1NYXNzYWNodXNl
    dHRzMQ8wDQYDVQQHDAZCb3N0b24xHTAbBgNVBAoMFEV4YW1wbGUgT3JnYW5pemF0
    aW9uMSIwIAYDVQQDDBlDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uMSswKQYJKoZI
    hvcNAQkBFhxjdXN0b21lci1zZXJ2aWNlQGV4YW1wbGUub3JnMIIBojANBgkqhkiG
    9w0BAQEFAAOCAY8AMIIBigKCAYEArtyHIeEmm1Mi2iR7lRW9NPxAyS9Bh8PxE1bF
    KPbRo1BWdFYosDADMcxdh9juycsihFEm/t9ncBeBeLI1UuzEb/K+FW1aJnfk+aZz
    A21pg1z0rRj7iShpKw8f0aihzaTiaBOlSscoYDWeBy7pe5Q/eL7VRuqglZhVk7ZL
    Spw8xbVToFPYy2Ih56wmd4x+w4I9DSCsmiEE1wtWuZteVlgecfMsY/XzozHBTkk4
    Frh8Pxj/3kvYTYU52jsczAILDlpUK4ga7XGMo23QouXdFXWI8KM6XfORWCqWU+2V
    4B9MnjjG8jrO+OCDHQHJqBxrkMYW+GkbhBq8YOngQQH/tZ8Cj8vf0ZXEQou0LWmo
    VNfZYuqCGDJ5Ig0lADmm+lBwtSeM9Ppjq0fVX4/u++oo36LYinwNoBAm3rQlBNI5
    MUwVOrrvOhiWdYvYSj3fwCkb1aKBofFqPMr3/nS+3VOLgGp7v7atCTfWG7fxf5E8
    vh27y1jq3FPKPY00rNws6V3QZuNXAgMBAAGjgZwwgZkwCQYDVR0TBAIwADALBgNV
    HQ8EBAMCBeAwYAYDVR0RBFkwV4IPd3d3LmV4YW1wbGUub3JnoBkGCWCGSAGG+VsE
    BqAMDAoxMjM0NTY3ODkzhilodHRwczovL2V4YW1wbGUub3JnL2ZoaXIvT3JnYW5p
    emF0aW9uLzEyMzAdBgNVHQ4EFgQU5u/bNQtps2mkOuYBVOF/Oax161gwDQYJKoZI
    hvcNAQELBQADggGBABiLOU39NEySzZSGz2aNhbMzUV5RaTwrpDxDvYjDX3jEP/js
    mj4/pN+L5RYBXsBfYxSUubQLeVvkf5fv+oGrmeCW+fX8yE1rl+q81CCL+Q8LOOzA
    ZFuEeYE9ieczY7fO18MpF8nC14CDQb6DN10QaAtbhTFakZeOqZaUgToDfINsn7jz
    a/bpt1Keu5vUsu1qFgjApzA6+MalINUkHma2FK+z2Yfy0W/NhupbLcWEn1RyuUBT
    Qwssm9wRPDE/LoSUA3pmmqPDl87d9tGFDK/ylQTuaql5tF02ljz8wYQiSRf5nzxq
    TmtnMCmvhyax75n50to/Tn4lh/j1iko+wCAWTMCNkb+m4G1msdoUYnEYn/TizW9v
    K3LhVTW5ZdI+uVyasdBhRLoylwYidUGCahvJfDSGk0xS74hUXb223AmziSKE3TFP
    xSnZEv3zi8mOkzsMSubjnpJqrnQXoBnNI8s+j0IyZQ29Zmd8CLLqmgkIOVOuacCo
    kXvKDWkUmkByRO6LwA==
    -----END CERTIFICATE-----
</pre>

**10. Verify Signature using the public key or the X.509 Certificate**

Alternatively:
1. visit https://jwt.io.
2. At the top of the page, select "RS256" for the algorithm.
3. Paste the JWS value printed below into the “Encoded” field.
4. The plaintext JWT will be displayed in the “Decoded:Payload” field.
5. The X509 Cert above will appear in the "Verify Signature" box.
6. If verified, a “Signature Verified” message will appear  in the bottom left hand corner.


```python
recd_jws
```



<pre  style="border:0; background:white; overflow-wrap:break-word;">
    'eyJhbGciOiJSUzI1NiIsImtpZCI6ImU2ZWZkYjM1MGI2OWIzNjlhNDNhZTYwMTU0ZTE3ZjM5YWM3NWViNTgiLCJrdHkiOiJSUyIsInNpZ1QiOiIyMDIwLTEwLTIzVDA0OjU0OjU2LjA0OCswMDowMCIsInNyQ21zIjpbeyJjb21tSWQiOnsiZGVzYyI6IlZlcmlmaWNhdGlvbiBTaWduYXR1cmUiLCJpZCI6InVybjpvaWQ6MS4yLjg0MC4xMDA2NS4xLjEyLjEuNSJ9LCJjb21tUXVhbHMiOlsiVmVyaWZpY2F0aW9uIG9mIG1lZGljYWwgcmVjb3JkIGludGVncml0eSJdfV0sInR5cCI6IkpXVCIsIng1YyI6WyJNSUlGZVRDQ0ErR2dBd0lCQWdJVU9jRnFMT0JtdDdWUjZ5NEZHbjAwUVNGTVhKZ3dEUVlKS29aSWh2Y05BUUVMQlFBd2dhWXhDekFKQmdOVkJBWVRBbFZUTVJZd0ZBWURWUVFJREExTllYTnpZV05vZFhObGRIUnpNUTh3RFFZRFZRUUhEQVpDYjNOMGIyNHhIVEFiQmdOVkJBb01GRVY0WVcxd2JHVWdUM0puWVc1cGVtRjBhVzl1TVNJd0lBWURWUVFEREJsRFJFVllJRVY0WVcxd2JHVWdUM0puWVc1cGVtRjBhVzl1TVNzd0tRWUpLb1pJaHZjTkFRa0JGaHhqZFhOMGIyMWxjaTF6WlhKMmFXTmxRR1Y0WVcxd2JHVXViM0puTUI0WERUSTFNRGN5TkRFNE1UUTBNRm9YRFRJMk1EY3hPVEU0TVRRME1Gb3dnYVl4Q3pBSkJnTlZCQVlUQWxWVE1SWXdGQVlEVlFRSURBMU5ZWE56WVdOb2RYTmxkSFJ6TVE4d0RRWURWUVFIREFaQ2IzTjBiMjR4SFRBYkJnTlZCQW9NRkVWNFlXMXdiR1VnVDNKbllXNXBlbUYwYVc5dU1TSXdJQVlEVlFRRERCbERSRVZZSUVWNFlXMXdiR1VnVDNKbllXNXBlbUYwYVc5dU1Tc3dLUVlKS29aSWh2Y05BUWtCRmh4amRYTjBiMjFsY2kxelpYSjJhV05sUUdWNFlXMXdiR1V1YjNKbk1JSUJvakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBWThBTUlJQmlnS0NBWUVBcnR5SEllRW1tMU1pMmlSN2xSVzlOUHhBeVM5Qmg4UHhFMWJGS1BiUm8xQldkRllvc0RBRE1jeGRoOWp1eWNzaWhGRW0vdDluY0JlQmVMSTFVdXpFYi9LK0ZXMWFKbmZrK2FaekEyMXBnMXowclJqN2lTaHBLdzhmMGFpaHphVGlhQk9sU3Njb1lEV2VCeTdwZTVRL2VMN1ZSdXFnbFpoVms3WkxTcHc4eGJWVG9GUFl5MkloNTZ3bWQ0eCt3NEk5RFNDc21pRUUxd3RXdVp0ZVZsZ2VjZk1zWS9Yem96SEJUa2s0RnJoOFB4ai8za3ZZVFlVNTJqc2N6QUlMRGxwVUs0Z2E3WEdNbzIzUW91WGRGWFdJOEtNNlhmT1JXQ3FXVSsyVjRCOU1uampHOGpyTytPQ0RIUUhKcUJ4cmtNWVcrR2tiaEJxOFlPbmdRUUgvdFo4Q2o4dmYwWlhFUW91MExXbW9WTmZaWXVxQ0dESjVJZzBsQURtbStsQnd0U2VNOVBwanEwZlZYNC91KytvbzM2TFlpbndOb0JBbTNyUWxCTkk1TVV3Vk9ycnZPaGlXZFl2WVNqM2Z3Q2tiMWFLQm9mRnFQTXIzL25TKzNWT0xnR3A3djdhdENUZldHN2Z4ZjVFOHZoMjd5MWpxM0ZQS1BZMDByTndzNlYzUVp1TlhBZ01CQUFHamdad3dnWmt3Q1FZRFZSMFRCQUl3QURBTEJnTlZIUThFQkFNQ0JlQXdZQVlEVlIwUkJGa3dWNElQZDNkM0xtVjRZVzF3YkdVdWIzSm5vQmtHQ1dDR1NBR0crVnNFQnFBTURBb3hNak0wTlRZM09Ea3poaWxvZEhSd2N6b3ZMMlY0WVcxd2JHVXViM0puTDJab2FYSXZUM0puWVc1cGVtRjBhVzl1THpFeU16QWRCZ05WSFE0RUZnUVU1dS9iTlF0cHMybWtPdVlCVk9GL09heDE2MWd3RFFZSktvWklodmNOQVFFTEJRQURnZ0dCQUJpTE9VMzlORXlTelpTR3oyYU5oYk16VVY1UmFUd3JwRHhEdllqRFgzakVQL2pzbWo0L3BOK0w1UllCWHNCZll4U1V1YlFMZVZ2a2Y1ZnYrb0dybWVDVytmWDh5RTFybCtxODFDQ0wrUThMT096QVpGdUVlWUU5aWVjelk3Zk8xOE1wRjhuQzE0Q0RRYjZETjEwUWFBdGJoVEZha1plT3FaYVVnVG9EZklOc243anphL2JwdDFLZXU1dlVzdTFxRmdqQXB6QTYrTWFsSU5Va0htYTJGSyt6MllmeTBXL05odXBiTGNXRW4xUnl1VUJUUXdzc205d1JQREUvTG9TVUEzcG1tcVBEbDg3ZDl0R0ZESy95bFFUdWFxbDV0RjAybGp6OHdZUWlTUmY1bnp4cVRtdG5NQ212aHlheDc1bjUwdG8vVG40bGgvajFpa28rd0NBV1RNQ05rYittNEcxbXNkb1VZbkVZbi9UaXpXOXZLM0xoVlRXNVpkSSt1Vnlhc2RCaFJMb3lsd1lpZFVHQ2FodkpmRFNHazB4Uzc0aFVYYjIyM0FtemlTS0UzVEZQeFNuWkV2M3ppOG1Pa3pzTVN1YmpucEpxcm5RWG9Cbk5JOHMrajBJeVpRMjlabWQ4Q0xMcW1na0lPVk91YWNDb2tYdktEV2tVbWtCeVJPNkx3QT09Il19.eyJlbnRyeSI6W3siZnVsbFVybCI6InVybjp1dWlkOjE3YTgwYThkLTRjZjEtNGRlYi1hMWZkLTJkYjExMzBlNWY3NiIsInJlc291cmNlIjp7ImF0dGVzdGVyIjpbeyJtb2RlIjoibGVnYWwiLCJwYXJ0eSI6eyJkaXNwbGF5IjoiRXhhbXBsZSBQcmFjdGl0aW9uZXIiLCJyZWZlcmVuY2UiOiJ1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMifSwidGltZSI6IjIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDAifV0sImF1dGhvciI6W3siZGlzcGxheSI6IkV4YW1wbGUgUHJhY3RpdGlvbmVyIiwicmVmZXJlbmNlIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIn1dLCJkYXRlIjoiMjAyMS0xMC0yNVQyMDoxNjoyOS0wNzowMCIsImVuY291bnRlciI6eyJkaXNwbGF5IjoiRXhhbXBsZSBFbmNvdW50ZXIiLCJyZWZlcmVuY2UiOiJ1cm46dXVpZDo1Y2U1YzgzYS0wMDBmLTQ3ZDItOTQxYy0wMzkzNThjYzkxMTIifSwiaWQiOiIxN2E4MGE4ZC00Y2YxLTRkZWItYTFmZC0yZGIxMTMwZTVmNzYiLCJyZXNvdXJjZVR5cGUiOiJDb21wb3NpdGlvbiIsInNlY3Rpb24iOlt7ImVudHJ5IjpbeyJyZWZlcmVuY2UiOiJ1cm46dXVpZDowMTRhNjhlYy1kNjkxLTQ5ZTAtYjk4MC05MWIwZDkyNGU1NzAifV0sInRpdGxlIjoiQWN0aXZlIENvbmRpdGlvbiAxIn1dLCJzdGF0dXMiOiJmaW5hbCIsInN1YmplY3QiOnsiZGlzcGxheSI6IkV4YW1wbGUgUGF0aWVudCIsInJlZmVyZW5jZSI6InVybjp1dWlkOjk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZSJ9LCJ0ZXh0Ijp7ImRpdiI6IjxkaXYgeG1sbnM9XCJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hodG1sXCI-PHA-PGI-R2VuZXJhdGVkIE5hcnJhdGl2ZTwvYj48L3A-PGRpdiBzdHlsZT1cImRpc3BsYXk6IGlubGluZS1ibG9jazsgYmFja2dyb3VuZC1jb2xvcjogI2Q5ZTBlNzsgcGFkZGluZzogNnB4OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQgIzhkYTFiNDsgYm9yZGVyLXJhZGl1czogNXB4OyBsaW5lLWhlaWdodDogNjAlXCI-PHAgc3R5bGU9XCJtYXJnaW4tYm90dG9tOiAwcHhcIj5SZXNvdXJjZSBcIjE3YTgwYThkLTRjZjEtNGRlYi1hMWZkLTJkYjExMzBlNWY3NlwiIDwvcD48L2Rpdj48cD48Yj5zdGF0dXM8L2I-OiBmaW5hbDwvcD48cD48Yj50eXBlPC9iPjogTWVkaWNhbCByZWNvcmRzIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vbG9pbmMub3JnL1wiPkxPSU5DPC9hPiMxMTUwMy0wKTwvc3Bhbj48L3A-PHA-PGI-ZW5jb3VudGVyPC9iPjogPGEgaHJlZj1cIiNFbmNvdW50ZXJfNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyXCI-U2VlIGFib3ZlICh1cm46dXVpZDo1Y2U1YzgzYS0wMDBmLTQ3ZDItOTQxYy0wMzkzNThjYzkxMTI6IEV4YW1wbGUgRW5jb3VudGVyKTwvYT48L3A-PHA-PGI-ZGF0ZTwvYj46IDIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDA8L3A-PHA-PGI-YXV0aG9yPC9iPjogPGEgaHJlZj1cIiNQcmFjdGl0aW9uZXJfMDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjXCI-U2VlIGFib3ZlICh1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmM6IEV4YW1wbGUgUHJhY3RpdGlvbmVyKTwvYT48L3A-PHA-PGI-dGl0bGU8L2I-OiBBY3RpdmUgQ29uZGl0aW9uczwvcD48aDM-QXR0ZXN0ZXJzPC9oMz48dGFibGUgY2xhc3M9XCJncmlkXCI-PHRyPjx0ZD4tPC90ZD48dGQ-PGI-TW9kZTwvYj48L3RkPjx0ZD48Yj5UaW1lPC9iPjwvdGQ-PHRkPjxiPlBhcnR5PC9iPjwvdGQ-PC90cj48dHI-PHRkPio8L3RkPjx0ZD5sZWdhbDwvdGQ-PHRkPjIwMjEtMTAtMjVUMjA6MTY6MjktMDc6MDA8L3RkPjx0ZD48YSBocmVmPVwiI1ByYWN0aXRpb25lcl8wODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmNcIj5TZWUgYWJvdmUgKHVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYzogRXhhbXBsZSBQcmFjdGl0aW9uZXIpPC9hPjwvdGQ-PC90cj48L3RhYmxlPjwvZGl2PiIsInN0YXR1cyI6ImdlbmVyYXRlZCJ9LCJ0aXRsZSI6IkFjdGl2ZSBDb25kaXRpb25zIiwidHlwZSI6eyJjb2RpbmciOlt7ImNvZGUiOiIxMTUwMy0wIiwic3lzdGVtIjoiaHR0cDovL2xvaW5jLm9yZyJ9XSwidGV4dCI6Ik1lZGljYWwgcmVjb3JkcyJ9fX0seyJmdWxsVXJsIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIiwicmVzb3VyY2UiOnsiaWQiOiIwODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMiLCJtZXRhIjp7Imxhc3RVcGRhdGVkIjoiMjAxMy0wNS0wNVQxNjoxMzowM1oifSwibmFtZSI6W3siZmFtaWx5IjoiSGFuY29jayIsImdpdmVuIjpbIkpvaG4iXX1dLCJyZXNvdXJjZVR5cGUiOiJQcmFjdGl0aW9uZXIiLCJ0ZXh0Ijp7ImRpdiI6IjxkaXYgeG1sbnM9XCJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hodG1sXCI-PHA-PGI-R2VuZXJhdGVkIE5hcnJhdGl2ZTwvYj48L3A-PGRpdiBzdHlsZT1cImRpc3BsYXk6IGlubGluZS1ibG9jazsgYmFja2dyb3VuZC1jb2xvcjogI2Q5ZTBlNzsgcGFkZGluZzogNnB4OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQgIzhkYTFiNDsgYm9yZGVyLXJhZGl1czogNXB4OyBsaW5lLWhlaWdodDogNjAlXCI-PHAgc3R5bGU9XCJtYXJnaW4tYm90dG9tOiAwcHhcIj5SZXNvdXJjZSBcIjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliY1wiIFVwZGF0ZWQgXCIyMDEzLTA1LTA1VDE2OjEzOjAzWlwiIDwvcD48L2Rpdj48cD48Yj5uYW1lPC9iPjogSm9obiBIYW5jb2NrIDwvcD48L2Rpdj4iLCJzdGF0dXMiOiJnZW5lcmF0ZWQifX19LHsiZnVsbFVybCI6InVybjp1dWlkOjk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZSIsInJlc291cmNlIjp7ImFjdGl2ZSI6dHJ1ZSwiaWQiOiI5NzBhZjZjOS01YmJkLTQwNjctYjZjMS1kOWIyYzgyM2FlY2UiLCJuYW1lIjpbeyJmYW1pbHkiOiJQYXRpZW50IiwiZ2l2ZW4iOlsiQ0RFWCBFeGFtcGxlIl0sInRleHQiOiJDREVYIEV4YW1wbGUgUGF0aWVudCJ9XSwicmVzb3VyY2VUeXBlIjoiUGF0aWVudCIsInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiOTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlXCIgPC9wPjwvZGl2PjxwPjxiPmFjdGl2ZTwvYj46IHRydWU8L3A-PHA-PGI-bmFtZTwvYj46IENERVggRXhhbXBsZSBQYXRpZW50PC9wPjwvZGl2PiIsInN0YXR1cyI6ImdlbmVyYXRlZCJ9fX0seyJmdWxsVXJsIjoidXJuOnV1aWQ6MDE0YTY4ZWMtZDY5MS00OWUwLWI5ODAtOTFiMGQ5MjRlNTcwIiwicmVzb3VyY2UiOnsiYXNzZXJ0ZXIiOnsicmVmZXJlbmNlIjoidXJuOnV1aWQ6MDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjIn0sImNhdGVnb3J5IjpbeyJjb2RpbmciOlt7ImNvZGUiOiI1NTYwNzAwNiIsImRpc3BsYXkiOiJQcm9ibGVtIiwic3lzdGVtIjoiaHR0cDovL3Nub21lZC5pbmZvL3NjdCJ9LHsiY29kZSI6Ijc1MzI2LTkiLCJkaXNwbGF5IjoiUHJvYmxlbSIsInN5c3RlbSI6Imh0dHA6Ly9sb2luYy5vcmcifV19XSwiY2xpbmljYWxTdGF0dXMiOnsiY29kaW5nIjpbeyJjb2RlIjoiYWN0aXZlIiwic3lzdGVtIjoiaHR0cDovL3Rlcm1pbm9sb2d5LmhsNy5vcmcvQ29kZVN5c3RlbS9jb25kaXRpb24tY2xpbmljYWwifV19LCJjb2RlIjp7ImNvZGluZyI6W3siY29kZSI6IjQ0MDU0MDA2IiwiZGlzcGxheSI6IlR5cGUgMiBEaWFiZXRlcyBNZWxsaXR1cyIsInN5c3RlbSI6Imh0dHA6Ly9zbm9tZWQuaW5mby9zY3QifV19LCJpZCI6IjAxNGE2OGVjLWQ2OTEtNDllMC1iOTgwLTkxYjBkOTI0ZTU3MCIsImlkZW50aWZpZXIiOlt7InN5c3RlbSI6InVybjpvaWQ6MS4zLjYuMS40LjEuMjI4MTIuNC4xMTEuMC40LjEuMi4xIiwidmFsdWUiOiIxIn1dLCJvbnNldERhdGVUaW1lIjoiMjAwNiIsInJlc291cmNlVHlwZSI6IkNvbmRpdGlvbiIsInN1YmplY3QiOnsicmVmZXJlbmNlIjoidXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlIn0sInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiMDE0YTY4ZWMtZDY5MS00OWUwLWI5ODAtOTFiMGQ5MjRlNTcwXCIgPC9wPjwvZGl2PjxwPjxiPmlkZW50aWZpZXI8L2I-OiBpZDogMTwvcD48cD48Yj5jbGluaWNhbFN0YXR1czwvYj46IEFjdGl2ZSA8c3BhbiBzdHlsZT1cImJhY2tncm91bmQ6IExpZ2h0R29sZGVuUm9kWWVsbG93OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQga2hha2lcIj4gKDxhIGhyZWY9XCJodHRwOi8vdGVybWlub2xvZ3kuaGw3Lm9yZy8zLjAuMC9Db2RlU3lzdGVtLWNvbmRpdGlvbi1jbGluaWNhbC5odG1sXCI-Q29uZGl0aW9uIENsaW5pY2FsIFN0YXR1cyBDb2RlczwvYT4jYWN0aXZlKTwvc3Bhbj48L3A-PHA-PGI-Y2F0ZWdvcnk8L2I-OiBQcm9ibGVtIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vYnJvd3Nlci5paHRzZG90b29scy5vcmcvXCI-U05PTUVEIENUPC9hPiM1NTYwNzAwNjsgPGEgaHJlZj1cImh0dHBzOi8vbG9pbmMub3JnL1wiPkxPSU5DPC9hPiM3NTMyNi05KTwvc3Bhbj48L3A-PHA-PGI-Y29kZTwvYj46IFR5cGUgMiBEaWFiZXRlcyBNZWxsaXR1cyA8c3BhbiBzdHlsZT1cImJhY2tncm91bmQ6IExpZ2h0R29sZGVuUm9kWWVsbG93OyBtYXJnaW46IDRweDsgYm9yZGVyOiAxcHggc29saWQga2hha2lcIj4gKDxhIGhyZWY9XCJodHRwczovL2Jyb3dzZXIuaWh0c2RvdG9vbHMub3JnL1wiPlNOT01FRCBDVDwvYT4jNDQwNTQwMDYpPC9zcGFuPjwvcD48cD48Yj5zdWJqZWN0PC9iPjogPGEgaHJlZj1cIiNQYXRpZW50Xzk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZVwiPlNlZSBhYm92ZSAodXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlKTwvYT48L3A-PHA-PGI-b25zZXQ8L2I-OiAyMDA2LTAxLTAxPC9wPjxwPjxiPmFzc2VydGVyPC9iPjogPGEgaHJlZj1cIiNQcmFjdGl0aW9uZXJfMDgyMGMxNmQtOTFkZS00ZGZhLWEzYTYtZjE0MGE1MTZhOWJjXCI-U2VlIGFib3ZlICh1cm46dXVpZDowODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmMpPC9hPjwvcD48L2Rpdj4iLCJzdGF0dXMiOiJnZW5lcmF0ZWQifX19LHsiZnVsbFVybCI6InVybjp1dWlkOjVjZTVjODNhLTAwMGYtNDdkMi05NDFjLTAzOTM1OGNjOTExMiIsInJlc291cmNlIjp7ImNsYXNzIjp7ImNvZGUiOiJFTUVSIiwic3lzdGVtIjoiaHR0cDovL3Rlcm1pbm9sb2d5LmhsNy5vcmcvQ29kZVN5c3RlbS92My1BY3RDb2RlIn0sImlkIjoiNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyIiwicGFydGljaXBhbnQiOlt7ImluZGl2aWR1YWwiOnsiZGlzcGxheSI6IkpvaG4gSGFuY29jayIsInJlZmVyZW5jZSI6InVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYyJ9fV0sInBlcmlvZCI6eyJlbmQiOiIyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwIiwic3RhcnQiOiIyMDIxLTEwLTI1VDIwOjEwOjI5LTA3OjAwIn0sInJlc291cmNlVHlwZSI6IkVuY291bnRlciIsInNlcnZpY2VQcm92aWRlciI6eyJkaXNwbGF5IjoiQ0RFWCBFeGFtcGxlIE9yZ2FuaXphdGlvbiIsInJlZmVyZW5jZSI6InVybjp1dWlkOmUzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhMyJ9LCJzdGF0dXMiOiJmaW5pc2hlZCIsInN1YmplY3QiOnsiZGlzcGxheSI6IkNERVggRXhhbXBsZSBQYXRpZW50IiwicmVmZXJlbmNlIjoidXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlIn0sInRleHQiOnsiZGl2IjoiPGRpdiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzE5OTkveGh0bWxcIj48cD48Yj5HZW5lcmF0ZWQgTmFycmF0aXZlPC9iPjwvcD48ZGl2IHN0eWxlPVwiZGlzcGxheTogaW5saW5lLWJsb2NrOyBiYWNrZ3JvdW5kLWNvbG9yOiAjZDllMGU3OyBwYWRkaW5nOiA2cHg7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCAjOGRhMWI0OyBib3JkZXItcmFkaXVzOiA1cHg7IGxpbmUtaGVpZ2h0OiA2MCVcIj48cCBzdHlsZT1cIm1hcmdpbi1ib3R0b206IDBweFwiPlJlc291cmNlIFwiNWNlNWM4M2EtMDAwZi00N2QyLTk0MWMtMDM5MzU4Y2M5MTEyXCIgPC9wPjwvZGl2PjxwPjxiPnN0YXR1czwvYj46IGZpbmlzaGVkPC9wPjxwPjxiPmNsYXNzPC9iPjogZW1lcmdlbmN5IChEZXRhaWxzOiBodHRwOi8vdGVybWlub2xvZ3kuaGw3Lm9yZy9Db2RlU3lzdGVtL3YzLUFjdENvZGUgY29kZSBFTUVSID0gJ2VtZXJnZW5jeScsIHN0YXRlZCBhcyAnbnVsbCcpPC9wPjxwPjxiPnR5cGU8L2I-OiBVbmtub3duIChxdWFsaWZpZXIgdmFsdWUpIDxzcGFuIHN0eWxlPVwiYmFja2dyb3VuZDogTGlnaHRHb2xkZW5Sb2RZZWxsb3c7IG1hcmdpbjogNHB4OyBib3JkZXI6IDFweCBzb2xpZCBraGFraVwiPiAoPGEgaHJlZj1cImh0dHBzOi8vYnJvd3Nlci5paHRzZG90b29scy5vcmcvXCI-U05PTUVEIENUPC9hPiMyNjE2NjUwMDYpPC9zcGFuPjwvcD48cD48Yj5zdWJqZWN0PC9iPjogPGEgaHJlZj1cIiNQYXRpZW50Xzk3MGFmNmM5LTViYmQtNDA2Ny1iNmMxLWQ5YjJjODIzYWVjZVwiPlNlZSBhYm92ZSAodXJuOnV1aWQ6OTcwYWY2YzktNWJiZC00MDY3LWI2YzEtZDliMmM4MjNhZWNlOiBDREVYIEV4YW1wbGUgUGF0aWVudCk8L2E-PC9wPjxoMz5QYXJ0aWNpcGFudHM8L2gzPjx0YWJsZSBjbGFzcz1cImdyaWRcIj48dHI-PHRkPi08L3RkPjx0ZD48Yj5JbmRpdmlkdWFsPC9iPjwvdGQ-PC90cj48dHI-PHRkPio8L3RkPjx0ZD48YSBocmVmPVwiI1ByYWN0aXRpb25lcl8wODIwYzE2ZC05MWRlLTRkZmEtYTNhNi1mMTQwYTUxNmE5YmNcIj5TZWUgYWJvdmUgKHVybjp1dWlkOjA4MjBjMTZkLTkxZGUtNGRmYS1hM2E2LWYxNDBhNTE2YTliYzogSm9obiBIYW5jb2NrKTwvYT48L3RkPjwvdHI-PC90YWJsZT48cD48Yj5wZXJpb2Q8L2I-OiAyMDIxLTEwLTI1VDIwOjEwOjI5LTA3OjAwIC0tJmd0OyAyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwPC9wPjxwPjxiPnNlcnZpY2VQcm92aWRlcjwvYj46IDxhIGhyZWY9XCIjT3JnYW5pemF0aW9uX2UzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhM1wiPlNlZSBhYm92ZSAodXJuOnV1aWQ6ZTM3ZjAwNGItZGMxMC00MjJiLWI4MzMtY2RhYTEwYTA1NWEzOiBDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uKTwvYT48L3A-PC9kaXY-Iiwic3RhdHVzIjoiZ2VuZXJhdGVkIn0sInR5cGUiOlt7ImNvZGluZyI6W3siY29kZSI6IjI2MTY2NTAwNiIsImRpc3BsYXkiOiJVbmtub3duIChxdWFsaWZpZXIgdmFsdWUpIiwic3lzdGVtIjoiaHR0cDovL3Nub21lZC5pbmZvL3NjdCJ9XSwidGV4dCI6IlVua25vd24gKHF1YWxpZmllciB2YWx1ZSkifV19fSx7ImZ1bGxVcmwiOiJ1cm46dXVpZDplMzdmMDA0Yi1kYzEwLTQyMmItYjgzMy1jZGFhMTBhMDU1YTMiLCJyZXNvdXJjZSI6eyJhY3RpdmUiOnRydWUsImFkZHJlc3MiOlt7ImNpdHkiOiJCb3N0b24iLCJjb3VudHJ5IjoiVVNBIiwibGluZSI6WyIxIENERVggTGFuZSJdLCJwb3N0YWxDb2RlIjoiMDEwMDIiLCJzdGF0ZSI6Ik1BIn1dLCJpZCI6ImUzN2YwMDRiLWRjMTAtNDIyYi1iODMzLWNkYWExMGEwNTVhMyIsIm5hbWUiOiJDREVYIEV4YW1wbGUgT3JnYW5pemF0aW9uIiwicmVzb3VyY2VUeXBlIjoiT3JnYW5pemF0aW9uIiwidGVsZWNvbSI6W3sic3lzdGVtIjoicGhvbmUiLCJ2YWx1ZSI6IigrMSkgNTU1LTU1NS01NTU1In0seyJzeXN0ZW0iOiJlbWFpbCIsInZhbHVlIjoiY3VzdG9tZXItc2VydmljZUBleGFtcGxlLm9yZyJ9XSwidGV4dCI6eyJkaXYiOiI8ZGl2IHhtbG5zPVwiaHR0cDovL3d3dy53My5vcmcvMTk5OS94aHRtbFwiPjxwPjxiPkdlbmVyYXRlZCBOYXJyYXRpdmU8L2I-PC9wPjxkaXYgc3R5bGU9XCJkaXNwbGF5OiBpbmxpbmUtYmxvY2s7IGJhY2tncm91bmQtY29sb3I6ICNkOWUwZTc7IHBhZGRpbmc6IDZweDsgbWFyZ2luOiA0cHg7IGJvcmRlcjogMXB4IHNvbGlkICM4ZGExYjQ7IGJvcmRlci1yYWRpdXM6IDVweDsgbGluZS1oZWlnaHQ6IDYwJVwiPjxwIHN0eWxlPVwibWFyZ2luLWJvdHRvbTogMHB4XCI-UmVzb3VyY2UgXCJlMzdmMDA0Yi1kYzEwLTQyMmItYjgzMy1jZGFhMTBhMDU1YTNcIiA8L3A-PC9kaXY-PHA-PGI-YWN0aXZlPC9iPjogdHJ1ZTwvcD48cD48Yj5uYW1lPC9iPjogQ0RFWCBFeGFtcGxlIE9yZ2FuaXphdGlvbjwvcD48cD48Yj50ZWxlY29tPC9iPjogcGg6ICgrMSkgNTU1LTU1NS01NTU1LCA8YSBocmVmPVwibWFpbHRvOmN1c3RvbWVyLXNlcnZpY2VAZXhhbXBsZS5vcmdcIj5jdXN0b21lci1zZXJ2aWNlQGV4YW1wbGUub3JnPC9hPjwvcD48cD48Yj5hZGRyZXNzPC9iPjogMSBDREVYIExhbmUgQm9zdG9uIE1BIDAxMDAyIFVTQSA8L3A-PC9kaXY-Iiwic3RhdHVzIjoiZ2VuZXJhdGVkIn19fV0sImlkZW50aWZpZXIiOnsic3lzdGVtIjoidXJuOmlldGY6cmZjOjM5ODYiLCJ2YWx1ZSI6InVybjp1dWlkOmMxNzM1MzVlLTEzNWUtNDhlMy1hYjY0LTM4YmFjYzY4ZGJhOCJ9LCJyZXNvdXJjZVR5cGUiOiJCdW5kbGUiLCJ0aW1lc3RhbXAiOiIyMDIxLTEwLTI1VDIwOjE2OjI5LTA3OjAwIiwidHlwZSI6ImRvY3VtZW50In0.cHbVVVD8FN5e9iVCWGQCOy9BlpWKZRgw-xGuZ1N3J_v3uRNl-CsgZb4ILpqdnWsk-l0rZQsfLB64CkogBolhn6-Z_Yk9uwFABhsGJV296wlSNRl5nbawIPeutns_bY1TK9JLPWTXObOIGPHWGDgEAlvMuYbuJtzMxeEFebSyPr_ejovpxbmGVxxo5dp2u6nzICsuCjB594w43i5Ylk1fCMq3qVgmTQuda-fEWFeiTaY-olg6vvf7hokofGEhwNaPP8acX8S6bKw8Mg8uNKvREM4C2XTidhsn1V25adSLJX6Va0p4J_9MlhTlSaOug58UrQSbkU0gK-PD0SMqGBQZKlum2dgorXefH65vA-DBeKLQP9-Ao8KqE4Hn_y2-luQunJ-1TPLZ60ch6KKk548RBRY4uBStaHpZJhb3Ez9A6s_A4ap1tXOe_wRspY-fnYbcytkaSN945gCG48bHywl4cRpq_qv0MdOWwQeUXCtWTp7Sh56Y-4x4nmhKZTTdxZ0H'
</pre>



```python
!openssl x509 -in recd_cert.der -inform DER -pubkey -noout > recd-public-key.pem
with open('recd-public-key.pem') as f:
    pem_public = f.read()
pem_public
```


<pre  style="border:0; background:white; overflow-wrap:break-word;">
    '-----BEGIN PUBLIC KEY-----\nMIIBojANBgkqhkiG9w0BAQEFAAOCAY8AMIIBigKCAYEArtyHIeEmm1Mi2iR7lRW9\nNPxAyS9Bh8PxE1bFKPbRo1BWdFYosDADMcxdh9juycsihFEm/t9ncBeBeLI1UuzE\nb/K+FW1aJnfk+aZzA21pg1z0rRj7iShpKw8f0aihzaTiaBOlSscoYDWeBy7pe5Q/\neL7VRuqglZhVk7ZLSpw8xbVToFPYy2Ih56wmd4x+w4I9DSCsmiEE1wtWuZteVlge\ncfMsY/XzozHBTkk4Frh8Pxj/3kvYTYU52jsczAILDlpUK4ga7XGMo23QouXdFXWI\n8KM6XfORWCqWU+2V4B9MnjjG8jrO+OCDHQHJqBxrkMYW+GkbhBq8YOngQQH/tZ8C\nj8vf0ZXEQou0LWmoVNfZYuqCGDJ5Ig0lADmm+lBwtSeM9Ppjq0fVX4/u++oo36LY\ninwNoBAm3rQlBNI5MUwVOrrvOhiWdYvYSj3fwCkb1aKBofFqPMr3/nS+3VOLgGp7\nv7atCTfWG7fxf5E8vh27y1jq3FPKPY00rNws6V3QZuNXAgMBAAE=\n-----END PUBLIC KEY-----\n'
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
<pre  style="border:0; background:white; overflow-wrap:break-word;">
    #     #                                                ### 
    #     #  ######  #####   #  ######  #  ######  #####   ### 
    #     #  #       #    #  #  #       #  #       #    #  ### 
    #     #  #####   #    #  #  #####   #  #####   #    #   #  
     #   #   #       #####   #  #       #  #       #    #      
      # #    #       #   #   #  #       #  #       #    #  ### 
       #     ######  #    #  #  #       #  ######  #####   ### 
</pre>                                                               


</div><!-- new-content -->