
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001819d18b0 <.text+0x19d08b0>:
   1819d18b0:	56                   	push   rsi
   1819d18b1:	48 83 ec 20          	sub    rsp,0x20
   1819d18b5:	48 89 ce             	mov    rsi,rcx
   1819d18b8:	48 81 c1 10 01 00 00 	add    rcx,0x110
   1819d18bf:	e8 4c 29 bf ff       	call   0x1815c4210
   1819d18c4:	48 8b 86 08 01 00 00 	mov    rax,QWORD PTR [rsi+0x108]
   1819d18cb:	48 83 f8 10          	cmp    rax,0x10
   1819d18cf:	72 38                	jb     0x1819d1909
   1819d18d1:	48 8b 8e f0 00 00 00 	mov    rcx,QWORD PTR [rsi+0xf0]
   1819d18d8:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1819d18dc:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1819d18e3:	72 1f                	jb     0x1819d1904
   1819d18e5:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1819d18e9:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1819d18ed:	4c 29 c1             	sub    rcx,r8
   1819d18f0:	48 83 f9 20          	cmp    rcx,0x20
   1819d18f4:	0f 83 ad 00 00 00    	jae    0x1819d19a7
   1819d18fa:	48 83 c0 28          	add    rax,0x28
   1819d18fe:	48 89 c2             	mov    rdx,rax
   1819d1901:	4c 89 c1             	mov    rcx,r8
   1819d1904:	e8 d7 9f ad 05       	call   0x1874ab8e0
   1819d1909:	48 8b 8e e0 00 00 00 	mov    rcx,QWORD PTR [rsi+0xe0]
   1819d1910:	48 85 c9             	test   rcx,rcx
   1819d1913:	74 0c                	je     0x1819d1921
   1819d1915:	f0 ff 49 0c          	lock dec DWORD PTR [rcx+0xc]
   1819d1919:	75 06                	jne    0x1819d1921
   1819d191b:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1819d191e:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1819d1921:	48 8b 8e c8 00 00 00 	mov    rcx,QWORD PTR [rsi+0xc8]
   1819d1928:	48 85 c9             	test   rcx,rcx
   1819d192b:	74 13                	je     0x1819d1940
   1819d192d:	48 8d 86 90 00 00 00 	lea    rax,[rsi+0x90]
   1819d1934:	48 39 c1             	cmp    rcx,rax
   1819d1937:	0f 95 c2             	setne  dl
   1819d193a:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1819d193d:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1819d1940:	48 8b 8e 88 00 00 00 	mov    rcx,QWORD PTR [rsi+0x88]
   1819d1947:	48 85 c9             	test   rcx,rcx
   1819d194a:	74 10                	je     0x1819d195c
   1819d194c:	48 8d 46 50          	lea    rax,[rsi+0x50]
   1819d1950:	48 39 c1             	cmp    rcx,rax
   1819d1953:	0f 95 c2             	setne  dl
   1819d1956:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1819d1959:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1819d195c:	48 8b 4e 48          	mov    rcx,QWORD PTR [rsi+0x48]
   1819d1960:	48 85 c9             	test   rcx,rcx
   1819d1963:	74 10                	je     0x1819d1975
   1819d1965:	48 8d 46 10          	lea    rax,[rsi+0x10]
   1819d1969:	48 39 c1             	cmp    rcx,rax
   1819d196c:	0f 95 c2             	setne  dl
   1819d196f:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1819d1972:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1819d1975:	48 8b 76 08          	mov    rsi,QWORD PTR [rsi+0x8]
   1819d1979:	48 85 f6             	test   rsi,rsi
   1819d197c:	74 23                	je     0x1819d19a1
   1819d197e:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1819d1982:	75 1d                	jne    0x1819d19a1
   1819d1984:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1819d1987:	48 89 f1             	mov    rcx,rsi
   1819d198a:	ff 10                	call   QWORD PTR [rax]
   1819d198c:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1819d1990:	75 0f                	jne    0x1819d19a1
   1819d1992:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1819d1995:	48 89 f1             	mov    rcx,rsi
   1819d1998:	48 83 c4 20          	add    rsp,0x20
   1819d199c:	5e                   	pop    rsi
   1819d199d:	48 ff 60 08          	rex.W jmp QWORD PTR [rax+0x8]
   1819d19a1:	48 83 c4 20          	add    rsp,0x20
   1819d19a5:	5e                   	pop    rsi
   1819d19a6:	c3                   	ret
   1819d19a7:	e8 e0 b9 b3 05       	call   0x18750d38c
   1819d19ac:	cc                   	int3
