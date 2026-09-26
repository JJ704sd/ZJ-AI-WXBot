
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000180027b00 <.text+0x26b00>:
   180027b00:	8e b5 00 00 00 4c    	mov    ?,WORD PTR [rbp+0x4c000000]
   180027b06:	8b 4f 08             	mov    ecx,DWORD PTR [rdi+0x8]
   180027b09:	49 8d 04 59          	lea    rax,[r9+rbx*2]
   180027b0d:	48 89 d1             	mov    rcx,rdx
   180027b10:	eb 24                	jmp    0x180027b36
   180027b12:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   180027b19:	1f 84 00 00 00 00 00 
   180027b20:	45 89 d3             	mov    r11d,r10d
   180027b23:	44 89 19             	mov    DWORD PTR [rcx],r11d
   180027b26:	48 83 c1 04          	add    rcx,0x4
   180027b2a:	48 83 c2 04          	add    rdx,0x4
   180027b2e:	4d 89 c1             	mov    r9,r8
   180027b31:	49 39 c0             	cmp    r8,rax
   180027b34:	73 64                	jae    0x180027b9a
   180027b36:	4d 8d 41 02          	lea    r8,[r9+0x2]
   180027b3a:	41 0f b7 39          	movzx  edi,WORD PTR [r9]
   180027b3e:	44 0f b7 d7          	movzx  r10d,di
   180027b42:	41 89 fb             	mov    r11d,edi
   180027b45:	41 81 e3 00 f8 00 00 	and    r11d,0xf800
   180027b4c:	41 81 fb 00 d8 00 00 	cmp    r11d,0xd800
   180027b53:	75 cb                	jne    0x180027b20
   180027b55:	81 e7 00 dc 00 00    	and    edi,0xdc00
   180027b5b:	41 bb fd ff 00 00    	mov    r11d,0xfffd
   180027b61:	81 ff 00 d8 00 00    	cmp    edi,0xd800
   180027b67:	75 ba                	jne    0x180027b23
   180027b69:	49 39 c0             	cmp    r8,rax
   180027b6c:	73 b5                	jae    0x180027b23
   180027b6e:	41 0f b7 38          	movzx  edi,WORD PTR [r8]
   180027b72:	89 fb                	mov    ebx,edi
   180027b74:	81 e3 00 fc 00 00    	and    ebx,0xfc00
   180027b7a:	81 fb 00 dc 00 00    	cmp    ebx,0xdc00
   180027b80:	75 a1                	jne    0x180027b23
   180027b82:	49 83 c1 04          	add    r9,0x4
   180027b86:	41 c1 e2 0a          	shl    r10d,0xa
   180027b8a:	45 8d 1c 3a          	lea    r11d,[r10+rdi*1]
   180027b8e:	41 81 c3 00 24 a0 fc 	add    r11d,0xfca02400
   180027b95:	4d 89 c8             	mov    r8,r9
   180027b98:	eb 89                	jmp    0x180027b23
   180027b9a:	48 03 76 10          	add    rsi,QWORD PTR [rsi+0x10]
   180027b9e:	eb 1d                	jmp    0x180027bbd
   180027ba0:	48 8d 35 a9 3f 01 0b 	lea    rsi,[rip+0xb013fa9]        # 0x18b03bb50
   180027ba7:	49 89 36             	mov    QWORD PTR [r14],rsi
   180027baa:	48 8b 56 10          	mov    rdx,QWORD PTR [rsi+0x10]
   180027bae:	48                   	rex.W
   180027baf:	01                   	.byte 0x1
