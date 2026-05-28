| Header parameters/Elements in etsiU unsigned header parameter/Services | Presence in B-T level | Presence in B-LT level | Cardinality | References | Additional requirements and notes | FHIR | CDEX |
|-------------------------------------------------------------|-----------------------|------------------------|-------------|------------|-----------------------------------|---|---|
| alg | **shall be present** | **shall be present** | 1 | Clause 5.1.2 |  | ✅ |✅
| cty | conditioned presence | conditioned presence | 0 or 1 | Clause 5.1.3 | 2 |
| kid | may be present | may be present | 0 or 1 | Clause 5.1.4 |  |❌ | ✅ (conditional)
| x5u | may be present | may be present | 0 or 1 | Clause 5.1.5 |  |
| x5c | Conditioned presence | Conditioned presence | 0 or 1 | Clause 5.1.8 | 3 |✅ |✅ (conditional)
| sigT|**shall be present** | **shall be present** |1 |Clause 5.2.1 |a|✅ |✅
| crit | Conditioned presence | Conditioned presence |  | Clause 5.1.9 | 4 |
| Service: signing a reference of the signing certificate | Conditioned presence | Conditioned presence | 1 | Clause 5.2.1 | 3 |
| SPO: x5t#256 | conditioned presence | conditioned presence | 0 or 1 | Clause 5.1.7 |  |
| SPO: x5t#o | conditioned presence | conditioned presence | 0 or 1 | Clause 5.2.2 |  |
| SPO: sigX5ts | conditioned presence | conditioned presence | 0 or 1 | Clause 5.2.2 |  |
| sigD | may be present | may be present | 0 or 1 | Clause 5.2.8 |  |
| srAts | may be present | may be present | 0 or 1 | Clause 5.2.5 |  |
| srCms | may be present | may be present | ≥ 0 | Clause 5.2.3 |  |✅ |✅
| sigPl | may be present | may be present | 0 or 1 | Clause 5.2.4 |  |
| sigPId | may be present | may be present | 0 or 1 | Clause 5.2.7 |  |
| cSig | may be present | may be present | ≥ 0 | Clause 5.3.2 |  |
| adoTst | may be present | may be present | ≥ 0 | Clause 5.3.3 | 5 |
| sigPSt | may be present | may be present | 0 or 1 | Clause 5.3.3 | b |
| sigTst | **shall be present** | **shall be present** | B-T, B-LT, B-LTA: ≥ 1 | Clause 5.3.4 | c, d 5 | ❌ | ❌
| xVals | * | conditioned presence | 0 or 1 | Clause 5.3.5.1 | e, 6 |
| xRefs | * | shall not be present | B-B, B-T: 0 or 1 B-LT: 0 | Clause A.1.1 | f, g |
| axVals | * | conditioned presence | 0 or 1 | Clause 5.3.5.3 | e, 7 |
| axRefs | * | shall not be present | B-B, B-T: 0 or 1 B-LT: 0 | Clause A.1.3 | f, g, h |
| rVals | * | conditioned presence | 0 or 1 | Clause 5.3.5.2 | i, 8 |
| rRefs | * | shall not be present | B-B, B-T: 0 or 1 B-LT: 0 | Clause A.1.2 |  |
| arVals | * | conditioned presence | 0 or 1 | Clause 5.3.5.4 | i, 9 |
| arRefs | * | shall not be present | B-B, B-T: 0 or 1 B-LT: 0 | Clause A.1.4 | h |
| sigRTst | * | shall not be present | B-B, B-T: ≥ 0 B-LT: 0 | Clause A.1.5.1 |  |
| rfsTst | * | shall not be present | B-B, B-T: ≥ 0 B-LT: 0 | Clause A.1.5.2 |  |
| Service: Incorporation of validation data for electronic time-stamps | * | **shall be provided** | - | - | j, k 10 | ❌ | ❌
| SPO: tstVD | * | conditioned presence | ≥ 0 | Clause 5.3.6.1 |  |
| SPO: certificate and revocation values embedded in the electronic time-stamp itself | * | conditioned presence | ≥ 0 | - |  |
| arcTst | * | * | ≥ 1 | Clause 5.3.6.2 | l, m |


\* should not be incorporated to the signature (provided) in the corresponding level
sigPID can be used to explicitly declare the JAdES baseline signature level.


next steps review the CDex Requirements and the conditional requirments.

s 5.1.4 and 5.2.8.1

  example of B-t level
signatures:
    - 
        protected: eyJhbGciOiJSUzI1NiIsImtpZCI6Ik1GMHdXS1JXTUZReEZEQVNCZ05WQkFNTUMzTmxiR1l0YzJsbmJtVmtNUnd3R2dZRFZRUUtEQk5GZFhKdmNHVmhiaUJEYjIxdGFYTnphVzl1TVJFd0R3WURWUVFMREFoUVMwa3RWRVZUVkRFTE1Ba0dBMVVFQmhNQ1JWVUNBUUU9IiwieDV0I28iOnsiZGlnQWxnIjoiUzUxMiIsImRpZ1ZhbCI6ImNmQkJici1Ea0tKdkJDWGJVSGJZalZDUTRBVlR2UE94N3ZONmlsRVYxSURsejd0aTFTdnNPVjFQb2t5X2M5WHo5S3pxLXM0UXhJSGI1VklVcTJyalN3In0sIng1YyI6WyJNSUlFVmpDQ0FyNmdBd0lCQWdJQkFUQU5CZ2txaGtpRzl3MEJBUTBGQURCVU1SUXdFZ1lEVlFRRERBdHpaV3htTFhOcFoyNWxaREVjTUJvR0ExVUVDZ3dUUlhWeWIzQmxZVzRnUTI5dGJXbHpjMmx2YmpFUk1BOEdBMVVFQ3d3SVVFdEpMVlJGVTFReEN6QUpCZ05WQkFZVEFrVlZNQ0FYRFRJd01EY3pNREV6TlRNek1sb1lEekl3TlRBd056TXdNVE0xTXpNeVdqQlVNUlF3RWdZRFZRUUREQXR6Wld4bUxYTnBaMjVsWkRFY01Cb0dBMVVFQ2d3VFJYVnliM0JsWVc0Z1EyOXRiV2x6YzJsdmJqRVJNQThHQTFVRUN3d0lVRXRKTFZSRlUxUXhDekFKQmdOVkJBWVRBa1ZWTUlJQm9qQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FZOEFNSUlCaWdLQ0FZRUFxZXA2L3IyUnR5bjJvT2NHeW94UURIRVNmNTZqQTAyQ05wSkRWY25zUDdDTGZkVGtyNFlNYWhHY1Q3QS9La3RzN2UxbTQwbXpadE0vUTBWZzJrZjJSTHdqQWtCYTBWNWlnQ2FEWXdsYkZRWVhGNGJYNXRIYUFPMlFTZ25hcGd3dEdHMVVtL0duY2R6cSs5ZFBmUXVqUWpudDM3LzBDL2l1Wlh3WjJTZE9PNmRQeXJSMjhScWsxSXpkRGp6OXVmNVpUVExKQ2FzLzlLblp5dVRVN3dTMUx2RjJIMm5zbXYvSityNXBWY0VpUEcxWVRncStyaEgzeFJiNTdpb1RNYWR5S3c4NlBKT1BwZi9nVnRSVk11N0FTem51bitUK2lSTDZlNkJEc21nQ1BSckxiS0NVQ2tJSTE2V25teVdaeFZ1V2JDWlBKdUk3QnJPeGNNY1A1MUR3UUtVOENjcS9BRk01dFE0WTlsSUtJYmQ4UkhyVjV6RlpUTmJqTEpMeUQzMXVjZktmWXRXOXNVQTZhNzhuelltcE9YWWRDYVVSalZ1NnR4eG1GYTNaUWZDa0lIanYzV3dnTVdhSlNQQ25ucWZxY1lFSVpJcjFxQlByRmtsZktCckt4RGUrUXpaSkk4VkkwSjFYSUo4MEViQVA4V2JLNWEzWXFjN1VXcmRQUVVmWEFnTUJBQUdqTVRBdk1BNEdBMVVkRHdFQi93UUVBd0lHUURBZEJnTlZIUTRFRmdRVXFFa29FWFdMeVpaV0hodnJvSlBWSDUyTk1Db3dEUVlKS29aSWh2Y05BUUVOQlFBRGdnR0JBQ2xtYzNuQ2Q0bDFFaURXampHQTFEMGxJTTZRRWQyWERYa1RLNGszRGJTTGZqTEhvcW1kTHBMZFFKcmtYVUlOSlkxZCs4bStLQ2IrS1BMa2doWGo2TFk2TXh5dzNudm9GSTZ1cnJGMm90YVRCZDZNbENIUFUwRlpacGVkeWMrOFdRc005NFh1bElhdHRIRFhXcDJqMEUrNjlaNFZXYi9jRzV3RnRDdzlpeittWE5iZU9XT2NpL2lYbU9ra3h0RjBYTk5BL2Y1RnROYW5rbzdpUDVsUWNKcGhFSXU4WUhZdHl4OTBqTmd5b3FaQTFrRDYycnZSdDEvQ3greGxIcDJqS0Zpd0tYWDNQM0ppeTlPNGliS0FZOFRhdldzWlRDNmdkNmtmR1h1MWRWNUFuSnRnRGphdzVueE9xV3pPZnhSUEIrbUJLSnVQTmJWVFhLcG8wdXpqKzhJNitRdGV6TDZzVHA1aGVhMUFNQTN4YmNwK242R0pSa083WU11cVJQMFBZMVZWNnc1ZGVydUJaYW1aL1NqdUFpNDhLa1VwaFhoSGZBK3NBdDJxT1RteWY0WGJIR0ErNjNXSFpwZlJKK0dIVmFweUhBeHlqN1FhSTc3WStKWWRJUmxSTTNOZjdMcEIxNWVEblJiMlFuQmpuMFRPVHMyS1d4ZnZHWEFZNzBNeDJRPT0iXSwidHlwIjoiam9zZStqc29uIiwiaWF0IjoxNzU4NzQ4Njk3LCJzaWdEIjp7Im1JZCI6Imh0dHA6Ly91cmkuZXRzaS5vcmcvMTkxODIvT2JqZWN0SWRCeVVSSSIsInBhcnMiOlsic2lnbmF0dXJlcy5tZCJdLCJjdHlzIjpbIm9jdGV0LXN0cmVhbSJdfSwiY3JpdCI6WyJzaWdEIl19
        header:
            etsiU:
                - eyJzaWdUc3QiOnsidHN0VG9rZW5zIjpbeyJ2YWwiOiJNSUlKcVFZSktvWklodmNOQVFjQ29JSUptakNDQ1pZQ0FRTXhEVEFMQmdsZ2hrZ0JaUU1FQWdNd2J3WUxLb1pJaHZjTkFRa1FBUVNnWUFSZU1Gd0NBUUVHQXlvREJEQXZNQXNHQ1dDR1NBRmxBd1FDQVFRZ0JYQm9yWTc0TWxxdWYvL1FyNEd3MFpiN2I3TzR2Z1YraERQRnBZVnBCbXdDRUZDVnNpSjZqUnBTTkp5T0lpSEE3RFFZRHpJd01qVXdPVEkwTWpFeE9ERTRXcUNDQllVd2dnV0JNSUlEYWFBREFnRUNBaFFaTnlLOWQ3SkJuVytwenZ0RWYzN2N0WVB1aWpBTkJna3Foa2lHOXcwQkFRc0ZBREJSTVFzd0NRWURWUVFHRXdKQ1JURVZNQk1HQTFVRUNnd01SRk5USUZSRlUxUWdVRXRKTVJFd0R3WURWUVFMREFoVVJWTlVJRkJMU1RFWU1CWUdBMVVFQXd3UGMyVnNaaTF6YVdkdVpXUXRkSE5oTUI0WERUSXdNVEl4TmpBM01ETXpObG9YRFRNd01USXhOREEzTURNek5sb3dVVEVMTUFrR0ExVUVCaE1DUWtVeEZUQVRCZ05WQkFvTURFUlRVeUJVUlZOVUlGQkxTVEVSTUE4R0ExVUVDd3dJVkVWVFZDQlFTMGt4R0RBV0JnTlZCQU1NRDNObGJHWXRjMmxuYm1Wa0xYUnpZVENDQWlJd0RRWUpLb1pJaHZjTkFRRUJCUUFEZ2dJUEFEQ0NBZ29DZ2dJQkFNYlRWREk3TUpkdnU3L3pnbXF0QWtqaEdtbyt0VkkwV2ZSQnNxOFYrNThXTWlGNnlxQnRXdVJnVlNaQmsyRWdRcTlkYjhFOVIwd3N4MWVCQ3dTVlhXZENzd2FEenp2a1lVRVB3Y0s2TDVzQUFpbnZZZWZmM1JTWVBabnNvVlgzN2N3U2t1cE80bkJvckJBdHlCeUxSOVNPTE52T1E2U2M4aitoTHJ2eDBaSGk4N1p3WU5aLzZIYTVjVGE4MTI2VUtBTHNydGxXaDVRbmdXVE0xU3VHRzlaQk04Wkt1V3VZWGFRT2JNd1V3bWVJcG91c0J3ZDhXbUd3NVNsWXFvYkU5SGJpeThJTnU2SjlmR0I3aDdpZDBUbnZUS1g2cG9vNE0xdFRacDg0c3dEOVFDVE94c0ZIMmkzQVpOTytjakthTmsrS1NHK0tZRklDaXhlUlRxSmovYy9qNXU3QUpBcUFEYWxYL3kxVVFiZTcvUDVUdnVtSkhoQ2hQN1RNU0g1b1Zvb21oVnZMZERrRnZRMlYrVWdxbFh1eVIvZlJaSjcvdG9vVkhWMExaaFJ4NmR2ZEZTZERiTCtjVXBQQ2JVMFdRQmNmTHd1M3hiUDZyUTJJRlN2TmJza2xBeG4rR1lSSXk2UDNKbjZ5MllzbFM5eWpTQThEVklmaXg2a1RiTkxjY2xBU0szSE1FYytKb09zaHZacHVoNllvRlBVblF4QXY1NlA5RjRHeWhzbUxHNnF4bml1dE1lbTF4SVV1OWNYNjJOeGlIN21PVHk0MFVweGs5WGwrWDMyUERla0hzVFgwSVRTRmhBcEJobjh2RXRwQklYSDdueWZjYW5iTWRHNnQvUDdzalFsakswdDEzc0tmT0Q1RnRQTk4xS0NtS0xLSEM2SUhIVTdoSUJReEFnTUJBQUdqVVRCUE1Ba0dBMVVkRXdRQ01BQXdDd1lEVlIwUEJBUURBZ2VBTUJZR0ExVWRKUUVCL3dRTU1Bb0dDQ3NHQVFVRkJ3TUlNQjBHQTFVZERnUVdCQlRIOEZ6ckg0amZJY21jb3hPNmZQcllMVk9XaURBTkJna3Foa2lHOXcwQkFRc0ZBQU9DQWdFQWN1MVNDZ0YwWFJVMmFCbmlub1hDYkV1RUxCbG45RXBubGF2Q2NoQXkzOENZK3ZoWHFXOSszSmRKOUZZTDlSOWFHc1dkQ2VzbHFTNXVWdW5XeTJseTJzRDIvaldxMW9rTnNWWVBXZkpjditOaWx0enRNOTB4TlM2SDVMaGlhdDJWUkxMdWR4T0FwcEhBQlZxL3czU1d2UUFRdEl1a0YzZVVBMEdUUkp3OEhnNi9OaDNTRHV0UXI1T3lQd0U1ZGhIZnlBc0NpT3Q0RjVGRVVpRzVlU0FJdjZMODQ1bFdYUjAweVNxQmkxcy9kczh0aFNibEdTVDR0ZitKWVJNSzUxZHdFc2VkdzNpRjNhemJJR1l4UXRNYmlWaG9NWEF2OVZZNEdzdEtocmUyb2pDbVh4RVVvR014VHpQVlhYUlJyNWkxYjBNeDdyRTNKbXU4bUFKSGRsTG1SdlZjdVNVV3UydzRzeWN1R0h1cXJXZkE0MmxRSlVRN1JtS29LWGN6YW93UEhYaU5hQzFrVG5GSlJJYUtqNGZXeU5DUDJLWUpZdTZGeEdkUEFTbGdTSE9KaUd5R3U4TGUvcEFaNk1PWGRHUEZ4WmtiOUZLalQwN2tNeU5hZ0VWVXRKa3NXTktFMjNqUEM1WW9mU0MxQVI1YmRocnhaMkFIbGlXdURWd2JQRXNwYkVsamU3eHpub2lpQ1NWTHF6WlRYUThHZXc5VVhzWExKSVhuWUdEMDZFNlpLSjZ2MkxKNnVlQlRQWTQzRlpHTzg2WGZ3QUNIMTcwcWpua3NDMWZYbHFUYU0rZDloVEhMR1FaVjB2UFFRSlpueU1Mc1ZDZElyR2xuaUhCSUtVdzUvN240angwS0dnT2dZRCtSb0JZZUg5T3cvVU5EQ040bE4xQ3UxZFMwQlNBeGdnT0dNSUlEZ2dJQkFUQnBNRkV4Q3pBSkJnTlZCQVlUQWtKRk1SVXdFd1lEVlFRS0RBeEVVMU1nVkVWVFZDQlFTMGt4RVRBUEJnTlZCQXNNQ0ZSRlUxUWdVRXRKTVJnd0ZnWURWUVFEREE5elpXeG1MWE5wWjI1bFpDMTBjMkVDRkJrM0lyMTNza0dkYjZuTyswUi9mdHkxZys2S01Bc0dDV0NHU0FGbEF3UUNBNkNCOFRBYUJna3Foa2lHOXcwQkNRTXhEUVlMS29aSWh2Y05BUWtRQVFRd0hBWUpLb1pJaHZjTkFRa0ZNUThYRFRJMU1Ea3lOREl4TVRneE9Gb3dLd1lKS29aSWh2Y05BUWswTVI0d0hEQUxCZ2xnaGtnQlpRTUVBZ09oRFFZSktvWklodmNOQVFFTkJRQXdOd1lMS29aSWh2Y05BUWtRQWk4eEtEQW1NQ1F3SWdRZ05vMHZyMUd2YXhVRTNubG5kR3VFMHZPVVFWYjcrZTZyeXB2YkpZRm9nRjR3VHdZSktvWklodmNOQVFrRU1VSUVRQ3ZrRWJYbGc0RFJvKy9PcXV3M2FiRENiSkhQK294ZkQ5UVpKeHJSWDdrTmwrNWJZb2pTbWxhcGt0SlBqT3ZkVDBlTFYwMXkyVk9DNDZmY0dQdE9XVzB3RFFZSktvWklodmNOQVFFTkJRQUVnZ0lBYkF1bjBjSnd4eHdkNWp4dDZ5Yy9VcmtjSERSQTFDa3lHOU1TVU9mc29XN2ZLcWdEOVc4eXY2bXpTMWEzUHdSMXlJZUZrL2VJRzdxY3cxNmdUN2k2M2I5c2JjcG5FY2lGckFHNlFYTmFkd0RTNWFOekFobzFWKzVhbTErR2xhZVExenFQajlqNEthZE9GZEw4ZDhuYzNiSXRCdEdpSVdHbUxsak9QSEQ1eVdJbkZocUtFTDJaNUUvY2NDYTdSUWt2U2tuQkNtSk9HVC9RUitqeGMwd3VPTTRMb3BDOWlsQ2R6MnZQK2l3WDR4M25TNU9PbWtuY1VRanhiam90N0tpaHRUUDRXNnlGNzdra21UczU2aGcxVXV6b3B6aVlOczF5c05CZEpWMmthVVQyeGV6UXZmTG9IOVd5U1BuUFE3bi9Bai83dXJDakxZZ2pQVXZ4UGFZZDZEK0FOOGQ3OG9naFdJNnM0YlhzRHJzUmRFZUQyOG5mY2ZGR1pSZ0dDbkJ0V0dscTZKYlVSMzV2QmRiZVNkN3BGZk9mY1lnRS9jN2lSb0RvUlJzSzNNMlptYTU4bzhsUnBTTjhYeVFySFpybzBKU2dDYVo4NTJxQTdtTXJKbVc4NnBWQTFiZWJ6Z2RPQ3Y3UUsrdGhOc0hmNlYzL3FKb2pXakZhRjd4YUs5My8rNk1Xd3F5ZndpdGdPU3ExdFAxTDBwVi8vQTUxRGdPaWMzTlowTzFpMmI5NGhSN1JaSXp6dHhVUTBmQyt6ZFBGQkJaSGtRcGMxTkhaNnNRS0MzaGRqbDNhL0JoMzlHNnhkQ09MNmZNQ3Qzak51YlNYRWQyTnUrTE9NV2xBOUMvZFFIRjVFRURtRENqdE9CcHFyTXF2OUNlYlZ4MEJmS1BFaWN6aytFS1Z1ZGs9In1dfX0
        signature: GJPA_G3i6nS5QAxqq8rseXOX9nG6YTJGqy4pVNAdxNS7RGQz1DD5IWYK1pDlVlQmSpzjRpmrmFFOhD-RWbcfHm25w-wJMpWFMES43-QbMkxVw_qPEGDmQNk3W3w8eaDOjINZKPztGR1_-cFulVnLvqerBV6Aa0Ii37gZQlCW2VKEJd0ZuSib1Wp9Zlaky4-Y6jGS9F7HaqaiElUpz42i2B61TraEbftbWSAtxekQmRd4vPBWMaji1NUkeGNaMk8DnDA5Bx8UKivPUbYX_EczrCmFDv7CzIdUalMVg1-yFp4MqfN-E1YN0m0lu-At6asOtEyqwuCIiGO4_aBmpUOE4_WFuXR7gGT-1wPeoWjmZp3A9yepKkPCp20SKA4-vWgOPSJN8fbCKPV-uqYxY2T67QeLhcdSwmqsLDpC6n6NwEbAkWm3vmZNtqpah7WRzf874bk_bSCUS1QX36SbDnF1pLTGOpk-rDqp8b6GcOUld9usujl-5cZuRZ4UjUYnYDjo


The verification script:

CONFIG='tsa_config.cnf'
RESPONSE='response.tsr'
REQUEST='request.tsq'
CERT='/Users/ehaas/Documents/FHIR/davinci-ecdx/CDEX-Signatures/example_org_cert/cert.pem'

openssl ts -verify -in "$RESPONSE" -queryfile "$REQUEST" -CAfile "$CERT" -partial_chain -config $CONFIG

yields this error: 

Using configuration from tsa_config.cnf
8085430201000000:error:10800080:PKCS7 routines:PKCS7_get0_signers:signer certificate not found:crypto/pkcs7/pk7_smime.c:413:
Verification: FAILED

openssl ts -verify -in /Users/ehaas/Documents/FHIR/davinci-ecdx/CDEX-Signatures/response.tsr -queryfile /Users/ehaas/Documents/FHIR/davinci-ecdx/CDEX-Signatures/request.tsq -CAfile /Users/ehaas/Documents/FHIR/davinci-ecdx/CDEX-Signatures/example_org_cert/cert.pem -untrusted /Users/ehaas/Documents/FHIR/davinci-ecdx/CDEX-Signatures/example_org_cert/cert.pem -partial_chain