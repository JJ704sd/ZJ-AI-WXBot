
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001855b2540 <.text+0x55b1540>:
   1855b2540:	55                   	push   rbp
   1855b2541:	41 57                	push   r15
   1855b2543:	41 56                	push   r14
   1855b2545:	41 55                	push   r13
   1855b2547:	41 54                	push   r12
   1855b2549:	56                   	push   rsi
   1855b254a:	57                   	push   rdi
   1855b254b:	53                   	push   rbx
   1855b254c:	48 81 ec 08 02 00 00 	sub    rsp,0x208
   1855b2553:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   1855b255a:	00 
   1855b255b:	48 c7 85 80 01 00 00 	mov    QWORD PTR [rbp+0x180],0xfffffffffffffffe
   1855b2562:	fe ff ff ff 
   1855b2566:	49 89 d5             	mov    r13,rdx
   1855b2569:	48 89 cf             	mov    rdi,rcx
   1855b256c:	b9 02 00 00 00       	mov    ecx,0x2
   1855b2571:	e8 6a a8 ab fa       	call   0x18006cde0
   1855b2576:	85 c0                	test   eax,eax
   1855b2578:	0f 84 da 01 00 00    	je     0x1855b2758
   1855b257e:	48 8d 9d e0 00 00 00 	lea    rbx,[rbp+0xe0]
   1855b2585:	48 89 d9             	mov    rcx,rbx
   1855b2588:	e8 83 a9 ab fa       	call   0x18006cf10
   1855b258d:	48 83 bd f8 00 00 00 	cmp    QWORD PTR [rbp+0xf8],0x10
   1855b2594:	10 
   1855b2595:	72 07                	jb     0x1855b259e
   1855b2597:	48 8b 9d e0 00 00 00 	mov    rbx,QWORD PTR [rbp+0xe0]
   1855b259e:	48 8d 05 3b f3 26 04 	lea    rax,[rip+0x426f33b]        # 0x1898218e0
   1855b25a5:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b25aa:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b25b1:	00 00 
   1855b25b3:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b25b8:	c7 44 24 28 48 00 00 	mov    DWORD PTR [rsp+0x28],0x48
   1855b25bf:	00 
   1855b25c0:	4c 8d 0d 79 f3 26 04 	lea    r9,[rip+0x426f379]        # 0x189821940
   1855b25c7:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b25cb:	ba 02 00 00 00       	mov    edx,0x2
   1855b25d0:	49 89 d8             	mov    r8,rbx
   1855b25d3:	e8 98 ac ab fa       	call   0x18006d270
   1855b25d8:	90                   	nop
   1855b25d9:	0f 28 05 d0 35 79 03 	movaps xmm0,XMMWORD PTR [rip+0x37935d0]        # 0x188d45bb0
   1855b25e0:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   1855b25e7:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1855b25ee:	48 8d 9d 00 01 00 00 	lea    rbx,[rbp+0x100]
   1855b25f5:	48 89 d9             	mov    rcx,rbx
   1855b25f8:	48 89 fa             	mov    rdx,rdi
   1855b25fb:	e8 b0 e5 95 fd       	call   0x182f10bb0
   1855b2600:	90                   	nop
   1855b2601:	48 81 bd 10 01 00 00 	cmp    QWORD PTR [rbp+0x110],0xc01
   1855b2608:	01 0c 00 00 
   1855b260c:	72 23                	jb     0x1855b2631
   1855b260e:	48 c7 85 10 01 00 00 	mov    QWORD PTR [rbp+0x110],0xc00
   1855b2615:	00 0c 00 00 
   1855b2619:	48 83 bd 18 01 00 00 	cmp    QWORD PTR [rbp+0x118],0x10
   1855b2620:	10 
   1855b2621:	72 07                	jb     0x1855b262a
   1855b2623:	48 8b 9d 00 01 00 00 	mov    rbx,QWORD PTR [rbp+0x100]
   1855b262a:	c6 83 00 0c 00 00 00 	mov    BYTE PTR [rbx+0xc00],0x0
   1855b2631:	0f 28 85 00 01 00 00 	movaps xmm0,XMMWORD PTR [rbp+0x100]
   1855b2638:	0f 28 8d 10 01 00 00 	movaps xmm1,XMMWORD PTR [rbp+0x110]
   1855b263f:	0f 29 4d d0          	movaps XMMWORD PTR [rbp-0x30],xmm1
   1855b2643:	0f 29 45 c0          	movaps XMMWORD PTR [rbp-0x40],xmm0
   1855b2647:	48 83 7d d8 10       	cmp    QWORD PTR [rbp-0x28],0x10
   1855b264c:	72 06                	jb     0x1855b2654
   1855b264e:	48 8b 45 c0          	mov    rax,QWORD PTR [rbp-0x40]
   1855b2652:	eb 04                	jmp    0x1855b2658
   1855b2654:	48 8d 45 c0          	lea    rax,[rbp-0x40]
   1855b2658:	48 89 85 80 00 00 00 	mov    QWORD PTR [rbp+0x80],rax
   1855b265f:	c6 85 88 00 00 00 00 	mov    BYTE PTR [rbp+0x88],0x0
   1855b2666:	0f 57 c0             	xorps  xmm0,xmm0
   1855b2669:	0f 11 85 68 01 00 00 	movups XMMWORD PTR [rbp+0x168],xmm0
   1855b2670:	0f 11 85 58 01 00 00 	movups XMMWORD PTR [rbp+0x158],xmm0
   1855b2677:	0f 11 85 48 01 00 00 	movups XMMWORD PTR [rbp+0x148],xmm0
   1855b267e:	0f 11 85 38 01 00 00 	movups XMMWORD PTR [rbp+0x138],xmm0
   1855b2685:	0f 11 85 28 01 00 00 	movups XMMWORD PTR [rbp+0x128],xmm0
   1855b268c:	0f 11 85 18 01 00 00 	movups XMMWORD PTR [rbp+0x118],xmm0
   1855b2693:	0f 11 85 08 01 00 00 	movups XMMWORD PTR [rbp+0x108],xmm0
   1855b269a:	48 c7 85 78 01 00 00 	mov    QWORD PTR [rbp+0x178],0x0
   1855b26a1:	00 00 00 00 
   1855b26a5:	48 8d 85 80 00 00 00 	lea    rax,[rbp+0x80]
   1855b26ac:	48 89 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rax
   1855b26b3:	48 8d 15 76 f3 26 04 	lea    rdx,[rip+0x426f376]        # 0x189821a30
   1855b26ba:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b26be:	4c 8d 85 00 01 00 00 	lea    r8,[rbp+0x100]
   1855b26c5:	e8 46 b1 ab fa       	call   0x18006d810
   1855b26ca:	90                   	nop
   1855b26cb:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
   1855b26cf:	48 83 f8 10          	cmp    rax,0x10
   1855b26d3:	72 35                	jb     0x1855b270a
   1855b26d5:	48 8b 4d c0          	mov    rcx,QWORD PTR [rbp-0x40]
   1855b26d9:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1855b26dd:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1855b26e4:	72 1f                	jb     0x1855b2705
   1855b26e6:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1855b26ea:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1855b26ee:	4c 29 c1             	sub    rcx,r8
   1855b26f1:	48 83 f9 20          	cmp    rcx,0x20
   1855b26f5:	0f 83 81 31 00 00    	jae    0x1855b587c
   1855b26fb:	48 83 c0 28          	add    rax,0x28
   1855b26ff:	48 89 c2             	mov    rdx,rax
   1855b2702:	4c 89 c1             	mov    rcx,r8
   1855b2705:	e8 d6 91 ef 01       	call   0x1874ab8e0
   1855b270a:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b270e:	e8 5d ac ab fa       	call   0x18006d370
   1855b2713:	48 8b 85 f8 00 00 00 	mov    rax,QWORD PTR [rbp+0xf8]
   1855b271a:	48 83 f8 10          	cmp    rax,0x10
   1855b271e:	72 38                	jb     0x1855b2758
   1855b2720:	48 8b 8d e0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xe0]
   1855b2727:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1855b272b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1855b2732:	72 1f                	jb     0x1855b2753
   1855b2734:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1855b2738:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1855b273c:	4c 29 c1             	sub    rcx,r8
   1855b273f:	48 83 f9 20          	cmp    rcx,0x20
   1855b2743:	0f 83 33 31 00 00    	jae    0x1855b587c
   1855b2749:	48 83 c0 28          	add    rax,0x28
   1855b274d:	48 89 c2             	mov    rdx,rax
   1855b2750:	4c 89 c1             	mov    rcx,r8
   1855b2753:	e8 88 91 ef 01       	call   0x1874ab8e0
   1855b2758:	48 89 f9             	mov    rcx,rdi
   1855b275b:	e8 20 3b 0d fb       	call   0x180686280
   1855b2760:	bb 02 00 00 00       	mov    ebx,0x2
   1855b2765:	ff c8                	dec    eax
   1855b2767:	83 f8 20             	cmp    eax,0x20
   1855b276a:	0f 87 f5 30 00 00    	ja     0x1855b5865
   1855b2770:	48 8d 0d b9 f6 26 04 	lea    rcx,[rip+0x426f6b9]        # 0x189821e30
   1855b2777:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
   1855b277b:	48 01 c8             	add    rax,rcx
   1855b277e:	ff e0                	jmp    rax
   1855b2780:	48 89 f9             	mov    rcx,rdi
   1855b2783:	e8 58 2d 91 fd       	call   0x182ec54e0
   1855b2788:	48 85 c0             	test   rax,rax
   1855b278b:	75 11                	jne    0x1855b279e
   1855b278d:	48 89 f9             	mov    rcx,rdi
   1855b2790:	e8 4b 2d 91 fd       	call   0x182ec54e0
   1855b2795:	48 85 c0             	test   rax,rax
   1855b2798:	0f 84 ef 18 00 00    	je     0x1855b408d
   1855b279e:	48 89 c3             	mov    rbx,rax
   1855b27a1:	0f 28 05 08 34 79 03 	movaps xmm0,XMMWORD PTR [rip+0x3793408]        # 0x188d45bb0
   1855b27a8:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1855b27af:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   1855b27b6:	e8 15 81 00 00       	call   0x1855ba8d0
   1855b27bb:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b27c2:	48 b9 31 00 00 00 03 	movabs rcx,0x300000031
   1855b27c9:	00 00 00 
   1855b27cc:	48 89 88 18 01 00 00 	mov    QWORD PTR [rax+0x118],rcx
   1855b27d3:	48 89 f9             	mov    rcx,rdi
   1855b27d6:	e8 45 20 91 fd       	call   0x182ec4820
   1855b27db:	90                   	nop
   1855b27dc:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   1855b27e3:	48 8d b9 98 07 00 00 	lea    rdi,[rcx+0x798]
   1855b27ea:	48 39 c7             	cmp    rdi,rax
   1855b27ed:	0f 84 8a 0b 00 00    	je     0x1855b337d
   1855b27f3:	4c 8b 70 10          	mov    r14,QWORD PTR [rax+0x10]
   1855b27f7:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   1855b27fc:	72 03                	jb     0x1855b2801
   1855b27fe:	48 8b 00             	mov    rax,QWORD PTR [rax]
   1855b2801:	48 8b 91 b0 07 00 00 	mov    rdx,QWORD PTR [rcx+0x7b0]
   1855b2808:	49 39 d6             	cmp    r14,rdx
   1855b280b:	0f 86 49 0b 00 00    	jbe    0x1855b335a
   1855b2811:	48 89 f9             	mov    rcx,rdi
   1855b2814:	4c 89 f2             	mov    rdx,r14
   1855b2817:	49 89 c1             	mov    r9,rax
   1855b281a:	e8 31 b9 a8 fa       	call   0x18003e150
   1855b281f:	90                   	nop
   1855b2820:	e9 58 0b 00 00       	jmp    0x1855b337d
   1855b2825:	48 89 f9             	mov    rcx,rdi
   1855b2828:	e8 53 2c 91 fd       	call   0x182ec5480
   1855b282d:	48 89 c7             	mov    rdi,rax
   1855b2830:	0f 28 05 79 33 79 03 	movaps xmm0,XMMWORD PTR [rip+0x3793379]        # 0x188d45bb0
   1855b2837:	0f 29 45 f0          	movaps XMMWORD PTR [rbp-0x10],xmm0
   1855b283b:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b283f:	e8 bc 67 50 fc       	call   0x181ab9000
   1855b2844:	48 8b 75 f0          	mov    rsi,QWORD PTR [rbp-0x10]
   1855b2848:	48 b8 31 00 00 00 33 	movabs rax,0x3300000031
   1855b284f:	00 00 00 
   1855b2852:	48 89 86 18 01 00 00 	mov    QWORD PTR [rsi+0x118],rax
   1855b2859:	b9 70 02 00 00       	mov    ecx,0x270
   1855b285e:	e8 39 90 ef 01       	call   0x1874ab89c
   1855b2863:	90                   	nop
   1855b2864:	48 89 c3             	mov    rbx,rax
   1855b2867:	49 89 c6             	mov    r14,rax
   1855b286a:	48 b8 01 00 00 00 01 	movabs rax,0x100000001
   1855b2871:	00 00 00 
   1855b2874:	48 89 43 08          	mov    QWORD PTR [rbx+0x8],rax
   1855b2878:	48 8d 05 19 c8 7e 03 	lea    rax,[rip+0x37ec819]        # 0x188d9f098
   1855b287f:	48 89 03             	mov    QWORD PTR [rbx],rax
   1855b2882:	48 83 c3 10          	add    rbx,0x10
   1855b2886:	41 b8 48 02 00 00    	mov    r8d,0x248
   1855b288c:	48 89 d9             	mov    rcx,rbx
   1855b288f:	31 d2                	xor    edx,edx
   1855b2891:	e8 5a 1e f9 01       	call   0x1875446f0
   1855b2896:	49 c7 46 28 0f 00 00 	mov    QWORD PTR [r14+0x28],0xf
   1855b289d:	00 
   1855b289e:	0f 57 c0             	xorps  xmm0,xmm0
   1855b28a1:	41 0f 11 46 30       	movups XMMWORD PTR [r14+0x30],xmm0
   1855b28a6:	49 c7 46 40 00 00 00 	mov    QWORD PTR [r14+0x40],0x0
   1855b28ad:	00 
   1855b28ae:	49 c7 46 48 0f 00 00 	mov    QWORD PTR [r14+0x48],0xf
   1855b28b5:	00 
   1855b28b6:	41 0f 11 46 50       	movups XMMWORD PTR [r14+0x50],xmm0
   1855b28bb:	49 c7 46 60 00 00 00 	mov    QWORD PTR [r14+0x60],0x0
   1855b28c2:	00 
   1855b28c3:	49 c7 46 68 0f 00 00 	mov    QWORD PTR [r14+0x68],0xf
   1855b28ca:	00 
   1855b28cb:	41 0f 11 46 70       	movups XMMWORD PTR [r14+0x70],xmm0
   1855b28d0:	49 c7 86 80 00 00 00 	mov    QWORD PTR [r14+0x80],0x0
   1855b28d7:	00 00 00 00 
   1855b28db:	49 c7 86 88 00 00 00 	mov    QWORD PTR [r14+0x88],0xf
   1855b28e2:	0f 00 00 00 
   1855b28e6:	41 0f 11 86 90 00 00 	movups XMMWORD PTR [r14+0x90],xmm0
   1855b28ed:	00 
   1855b28ee:	49 c7 86 a0 00 00 00 	mov    QWORD PTR [r14+0xa0],0x0
   1855b28f5:	00 00 00 00 
   1855b28f9:	49 c7 86 a8 00 00 00 	mov    QWORD PTR [r14+0xa8],0xf
   1855b2900:	0f 00 00 00 
   1855b2904:	41 0f 11 86 b0 00 00 	movups XMMWORD PTR [r14+0xb0],xmm0
   1855b290b:	00 
   1855b290c:	49 c7 86 c0 00 00 00 	mov    QWORD PTR [r14+0xc0],0x0
   1855b2913:	00 00 00 00 
   1855b2917:	49 c7 86 c8 00 00 00 	mov    QWORD PTR [r14+0xc8],0xf
   1855b291e:	0f 00 00 00 
   1855b2922:	41 0f 11 86 d0 00 00 	movups XMMWORD PTR [r14+0xd0],xmm0
   1855b2929:	00 
   1855b292a:	49 c7 86 e0 00 00 00 	mov    QWORD PTR [r14+0xe0],0x0
   1855b2931:	00 00 00 00 
   1855b2935:	49 c7 86 e8 00 00 00 	mov    QWORD PTR [r14+0xe8],0xf
   1855b293c:	0f 00 00 00 
   1855b2940:	41 0f 11 86 f0 00 00 	movups XMMWORD PTR [r14+0xf0],xmm0
   1855b2947:	00 
   1855b2948:	49 c7 86 00 01 00 00 	mov    QWORD PTR [r14+0x100],0x0
   1855b294f:	00 00 00 00 
   1855b2953:	49 c7 86 08 01 00 00 	mov    QWORD PTR [r14+0x108],0xf
   1855b295a:	0f 00 00 00 
   1855b295e:	41 0f 11 86 10 01 00 	movups XMMWORD PTR [r14+0x110],xmm0
   1855b2965:	00 
   1855b2966:	49 c7 86 20 01 00 00 	mov    QWORD PTR [r14+0x120],0x0
   1855b296d:	00 00 00 00 
   1855b2971:	49 c7 86 28 01 00 00 	mov    QWORD PTR [r14+0x128],0xf
   1855b2978:	0f 00 00 00 
   1855b297c:	41 0f 11 86 30 01 00 	movups XMMWORD PTR [r14+0x130],xmm0
   1855b2983:	00 
   1855b2984:	49 c7 86 40 01 00 00 	mov    QWORD PTR [r14+0x140],0x0
   1855b298b:	00 00 00 00 
   1855b298f:	49 c7 86 48 01 00 00 	mov    QWORD PTR [r14+0x148],0xf
   1855b2996:	0f 00 00 00 
   1855b299a:	41 0f 11 86 50 01 00 	movups XMMWORD PTR [r14+0x150],xmm0
   1855b29a1:	00 
   1855b29a2:	49 c7 86 60 01 00 00 	mov    QWORD PTR [r14+0x160],0x0
   1855b29a9:	00 00 00 00 
   1855b29ad:	49 c7 86 68 01 00 00 	mov    QWORD PTR [r14+0x168],0xf
   1855b29b4:	0f 00 00 00 
   1855b29b8:	41 0f 11 86 70 01 00 	movups XMMWORD PTR [r14+0x170],xmm0
   1855b29bf:	00 
   1855b29c0:	49 c7 86 80 01 00 00 	mov    QWORD PTR [r14+0x180],0x0
   1855b29c7:	00 00 00 00 
   1855b29cb:	49 c7 86 88 01 00 00 	mov    QWORD PTR [r14+0x188],0xf
   1855b29d2:	0f 00 00 00 
   1855b29d6:	41 0f 11 86 90 01 00 	movups XMMWORD PTR [r14+0x190],xmm0
   1855b29dd:	00 
   1855b29de:	49 c7 86 a0 01 00 00 	mov    QWORD PTR [r14+0x1a0],0x0
   1855b29e5:	00 00 00 00 
   1855b29e9:	49 c7 86 a8 01 00 00 	mov    QWORD PTR [r14+0x1a8],0xf
   1855b29f0:	0f 00 00 00 
   1855b29f4:	41 0f 11 86 b0 01 00 	movups XMMWORD PTR [r14+0x1b0],xmm0
   1855b29fb:	00 
   1855b29fc:	49 c7 86 c0 01 00 00 	mov    QWORD PTR [r14+0x1c0],0x0
   1855b2a03:	00 00 00 00 
   1855b2a07:	49 c7 86 c8 01 00 00 	mov    QWORD PTR [r14+0x1c8],0xf
   1855b2a0e:	0f 00 00 00 
   1855b2a12:	41 0f 11 86 d0 01 00 	movups XMMWORD PTR [r14+0x1d0],xmm0
   1855b2a19:	00 
   1855b2a1a:	49 c7 86 e0 01 00 00 	mov    QWORD PTR [r14+0x1e0],0x0
   1855b2a21:	00 00 00 00 
   1855b2a25:	49 c7 86 e8 01 00 00 	mov    QWORD PTR [r14+0x1e8],0xf
   1855b2a2c:	0f 00 00 00 
   1855b2a30:	41 0f 11 86 f0 01 00 	movups XMMWORD PTR [r14+0x1f0],xmm0
   1855b2a37:	00 
   1855b2a38:	49 c7 86 00 02 00 00 	mov    QWORD PTR [r14+0x200],0x0
   1855b2a3f:	00 00 00 00 
   1855b2a43:	49 c7 86 08 02 00 00 	mov    QWORD PTR [r14+0x208],0xf
   1855b2a4a:	0f 00 00 00 
   1855b2a4e:	41 0f 11 86 10 02 00 	movups XMMWORD PTR [r14+0x210],xmm0
   1855b2a55:	00 
   1855b2a56:	49 c7 86 20 02 00 00 	mov    QWORD PTR [r14+0x220],0x0
   1855b2a5d:	00 00 00 00 
   1855b2a61:	49 c7 86 28 02 00 00 	mov    QWORD PTR [r14+0x228],0xf
   1855b2a68:	0f 00 00 00 
   1855b2a6c:	41 0f 11 86 30 02 00 	movups XMMWORD PTR [r14+0x230],xmm0
   1855b2a73:	00 
   1855b2a74:	49 c7 86 40 02 00 00 	mov    QWORD PTR [r14+0x240],0x0
   1855b2a7b:	00 00 00 00 
   1855b2a7f:	49 c7 86 48 02 00 00 	mov    QWORD PTR [r14+0x248],0xf
   1855b2a86:	0f 00 00 00 
   1855b2a8a:	41 0f 11 86 58 02 00 	movups XMMWORD PTR [r14+0x258],xmm0
   1855b2a91:	00 
   1855b2a92:	49 c7 86 68 02 00 00 	mov    QWORD PTR [r14+0x268],0x0
   1855b2a99:	00 00 00 00 
   1855b2a9d:	48 89 9e e0 07 00 00 	mov    QWORD PTR [rsi+0x7e0],rbx
   1855b2aa4:	48 8b 9e e8 07 00 00 	mov    rbx,QWORD PTR [rsi+0x7e8]
   1855b2aab:	4c 89 b6 e8 07 00 00 	mov    QWORD PTR [rsi+0x7e8],r14
   1855b2ab2:	48 85 db             	test   rbx,rbx
   1855b2ab5:	74 1d                	je     0x1855b2ad4
   1855b2ab7:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1855b2abb:	75 17                	jne    0x1855b2ad4
   1855b2abd:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1855b2ac0:	48 89 d9             	mov    rcx,rbx
   1855b2ac3:	ff 10                	call   QWORD PTR [rax]
   1855b2ac5:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1855b2ac9:	75 09                	jne    0x1855b2ad4
   1855b2acb:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1855b2ace:	48 89 d9             	mov    rcx,rbx
   1855b2ad1:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b2ad4:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1855b2ad8:	48 8b 88 e0 07 00 00 	mov    rcx,QWORD PTR [rax+0x7e0]
   1855b2adf:	48 89 fa             	mov    rdx,rdi
   1855b2ae2:	e8 39 ca 50 fd       	call   0x182abf520
   1855b2ae7:	90                   	nop
   1855b2ae8:	e9 32 1a 00 00       	jmp    0x1855b451f
   1855b2aed:	48 89 f9             	mov    rcx,rdi
   1855b2af0:	e8 0b 29 91 fd       	call   0x182ec5400
   1855b2af5:	48 89 c3             	mov    rbx,rax
   1855b2af8:	48 89 c1             	mov    rcx,rax
   1855b2afb:	e8 80 de 50 fb       	call   0x180ac0980
   1855b2b00:	84 c0                	test   al,al
   1855b2b02:	0f 84 b9 0c 00 00    	je     0x1855b37c1
   1855b2b08:	0f 28 05 a1 30 79 03 	movaps xmm0,XMMWORD PTR [rip+0x37930a1]        # 0x188d45bb0
   1855b2b0f:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1855b2b16:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   1855b2b1d:	e8 2e a5 f2 fc       	call   0x1824dd050
   1855b2b22:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b2b29:	48 b9 31 00 00 00 21 	movabs rcx,0x2100000031
   1855b2b30:	00 00 00 
   1855b2b33:	48 89 88 18 01 00 00 	mov    QWORD PTR [rax+0x118],rcx
   1855b2b3a:	48 89 f9             	mov    rcx,rdi
   1855b2b3d:	e8 5e 1a 91 fd       	call   0x182ec45a0
   1855b2b42:	90                   	nop
   1855b2b43:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   1855b2b4a:	4c 8d b1 58 07 00 00 	lea    r14,[rcx+0x758]
   1855b2b51:	49 39 c6             	cmp    r14,rax
   1855b2b54:	0f 84 59 1f 00 00    	je     0x1855b4ab3
   1855b2b5a:	4c 8b 78 10          	mov    r15,QWORD PTR [rax+0x10]
   1855b2b5e:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   1855b2b63:	72 03                	jb     0x1855b2b68
   1855b2b65:	48 8b 00             	mov    rax,QWORD PTR [rax]
   1855b2b68:	48 8b 91 70 07 00 00 	mov    rdx,QWORD PTR [rcx+0x770]
   1855b2b6f:	49 39 d7             	cmp    r15,rdx
   1855b2b72:	0f 86 18 1f 00 00    	jbe    0x1855b4a90
   1855b2b78:	4c 89 f1             	mov    rcx,r14
   1855b2b7b:	4c 89 fa             	mov    rdx,r15
   1855b2b7e:	49 89 c1             	mov    r9,rax
   1855b2b81:	e8 ca b5 a8 fa       	call   0x18003e150
   1855b2b86:	90                   	nop
   1855b2b87:	e9 27 1f 00 00       	jmp    0x1855b4ab3
   1855b2b8c:	48 89 f9             	mov    rcx,rdi
   1855b2b8f:	e8 cc 17 91 fd       	call   0x182ec4360
   1855b2b94:	48 83 f8 05          	cmp    rax,0x5
   1855b2b98:	0f 87 da 19 00 00    	ja     0x1855b4578
   1855b2b9e:	49 89 c6             	mov    r14,rax
   1855b2ba1:	b8 2a 00 00 00       	mov    eax,0x2a
   1855b2ba6:	4c 0f a3 f0          	bt     rax,r14
   1855b2baa:	0f 83 c8 19 00 00    	jae    0x1855b4578
   1855b2bb0:	b9 04 00 00 00       	mov    ecx,0x4
   1855b2bb5:	e8 26 a2 ab fa       	call   0x18006cde0
   1855b2bba:	85 c0                	test   eax,eax
   1855b2bbc:	0f 84 a3 2c 00 00    	je     0x1855b5865
   1855b2bc2:	48 8d b5 e0 00 00 00 	lea    rsi,[rbp+0xe0]
   1855b2bc9:	48 89 f1             	mov    rcx,rsi
   1855b2bcc:	e8 3f a3 ab fa       	call   0x18006cf10
   1855b2bd1:	48 83 bd f8 00 00 00 	cmp    QWORD PTR [rbp+0xf8],0x10
   1855b2bd8:	10 
   1855b2bd9:	72 07                	jb     0x1855b2be2
   1855b2bdb:	48 8b b5 e0 00 00 00 	mov    rsi,QWORD PTR [rbp+0xe0]
   1855b2be2:	48 8d 05 f7 ec 26 04 	lea    rax,[rip+0x426ecf7]        # 0x1898218e0
   1855b2be9:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b2bee:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b2bf5:	00 00 
   1855b2bf7:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b2bfc:	c7 44 24 28 27 01 00 	mov    DWORD PTR [rsp+0x28],0x127
   1855b2c03:	00 
   1855b2c04:	4c 8d 0d 35 ed 26 04 	lea    r9,[rip+0x426ed35]        # 0x189821940
   1855b2c0b:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b2c0f:	ba 04 00 00 00       	mov    edx,0x4
   1855b2c14:	49 89 f0             	mov    r8,rsi
   1855b2c17:	e8 54 a6 ab fa       	call   0x18006d270
   1855b2c1c:	90                   	nop
   1855b2c1d:	48 c7 85 80 00 00 00 	mov    QWORD PTR [rbp+0x80],0x0
   1855b2c24:	00 00 00 00 
   1855b2c28:	41 b8 07 00 00 00    	mov    r8d,0x7
   1855b2c2e:	48 8d 8d 87 00 00 00 	lea    rcx,[rbp+0x87]
   1855b2c35:	49 b9 cd cc cc cc cc 	movabs r9,0xcccccccccccccccd
   1855b2c3c:	cc cc cc 
   1855b2c3f:	4c 8d 15 2a 36 79 03 	lea    r10,[rip+0x379362a]        # 0x188d46270
   1855b2c46:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
   1855b2c4d:	00 00 00 
   1855b2c50:	4c 89 f0             	mov    rax,r14
   1855b2c53:	49 f7 e1             	mul    r9
   1855b2c56:	48 c1 ea 03          	shr    rdx,0x3
   1855b2c5a:	48 8d 04 12          	lea    rax,[rdx+rdx*1]
   1855b2c5e:	48 8d 04 80          	lea    rax,[rax+rax*4]
   1855b2c62:	4d 89 d3             	mov    r11,r10
   1855b2c65:	49 29 c3             	sub    r11,rax
   1855b2c68:	43 0f b6 44 33 23    	movzx  eax,BYTE PTR [r11+r14*1+0x23]
   1855b2c6e:	88 41 01             	mov    BYTE PTR [rcx+0x1],al
   1855b2c71:	48 ff c1             	inc    rcx
   1855b2c74:	49 ff c0             	inc    r8
   1855b2c77:	49 83 fe 09          	cmp    r14,0x9
   1855b2c7b:	49 89 d6             	mov    r14,rdx
   1855b2c7e:	77 d0                	ja     0x1855b2c50
   1855b2c80:	48 8d 85 88 00 00 00 	lea    rax,[rbp+0x88]
   1855b2c87:	c6 41 01 00          	mov    BYTE PTR [rcx+0x1],0x0
   1855b2c8b:	49 83 f8 09          	cmp    r8,0x9
   1855b2c8f:	72 2b                	jb     0x1855b2cbc
   1855b2c91:	48 8d 95 89 00 00 00 	lea    rdx,[rbp+0x89]
   1855b2c98:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   1855b2c9f:	00 
   1855b2ca0:	44 0f b6 01          	movzx  r8d,BYTE PTR [rcx]
   1855b2ca4:	44 0f b6 4a ff       	movzx  r9d,BYTE PTR [rdx-0x1]
   1855b2ca9:	44 88 09             	mov    BYTE PTR [rcx],r9b
   1855b2cac:	48 ff c9             	dec    rcx
   1855b2caf:	44 88 42 ff          	mov    BYTE PTR [rdx-0x1],r8b
   1855b2cb3:	48 39 ca             	cmp    rdx,rcx
   1855b2cb6:	48 8d 52 01          	lea    rdx,[rdx+0x1]
   1855b2cba:	72 e4                	jb     0x1855b2ca0
   1855b2cbc:	48 89 85 80 00 00 00 	mov    QWORD PTR [rbp+0x80],rax
   1855b2cc3:	0f 57 c0             	xorps  xmm0,xmm0
   1855b2cc6:	0f 11 85 68 01 00 00 	movups XMMWORD PTR [rbp+0x168],xmm0
   1855b2ccd:	0f 11 85 58 01 00 00 	movups XMMWORD PTR [rbp+0x158],xmm0
   1855b2cd4:	0f 11 85 48 01 00 00 	movups XMMWORD PTR [rbp+0x148],xmm0
   1855b2cdb:	0f 11 85 38 01 00 00 	movups XMMWORD PTR [rbp+0x138],xmm0
   1855b2ce2:	0f 11 85 28 01 00 00 	movups XMMWORD PTR [rbp+0x128],xmm0
   1855b2ce9:	0f 11 85 18 01 00 00 	movups XMMWORD PTR [rbp+0x118],xmm0
   1855b2cf0:	0f 11 85 08 01 00 00 	movups XMMWORD PTR [rbp+0x108],xmm0
   1855b2cf7:	48 c7 85 78 01 00 00 	mov    QWORD PTR [rbp+0x178],0x0
   1855b2cfe:	00 00 00 00 
   1855b2d02:	48 8d 85 80 00 00 00 	lea    rax,[rbp+0x80]
   1855b2d09:	48 89 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rax
   1855b2d10:	48 8d 15 99 ed 26 04 	lea    rdx,[rip+0x426ed99]        # 0x189821ab0
   1855b2d17:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b2d1b:	4c 8d 85 00 01 00 00 	lea    r8,[rbp+0x100]
   1855b2d22:	e8 e9 aa ab fa       	call   0x18006d810
   1855b2d27:	90                   	nop
   1855b2d28:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b2d2c:	e8 3f a6 ab fa       	call   0x18006d370
   1855b2d31:	48 8b 85 f8 00 00 00 	mov    rax,QWORD PTR [rbp+0xf8]
   1855b2d38:	48 83 f8 10          	cmp    rax,0x10
   1855b2d3c:	0f 82 23 2b 00 00    	jb     0x1855b5865
   1855b2d42:	48 8b 8d e0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xe0]
   1855b2d49:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1855b2d4d:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1855b2d54:	0f 83 bc 29 00 00    	jae    0x1855b5716
   1855b2d5a:	e9 d6 29 00 00       	jmp    0x1855b5735
   1855b2d5f:	48 89 f9             	mov    rcx,rdi
   1855b2d62:	e8 19 26 91 fd       	call   0x182ec5380
   1855b2d67:	48 89 c3             	mov    rbx,rax
   1855b2d6a:	48 89 f9             	mov    rcx,rdi
   1855b2d6d:	e8 6e 27 91 fd       	call   0x182ec54e0
   1855b2d72:	49 89 c6             	mov    r14,rax
   1855b2d75:	48 89 f9             	mov    rcx,rdi
   1855b2d78:	e8 43 1b 91 fd       	call   0x182ec48c0
   1855b2d7d:	49 89 c4             	mov    r12,rax
   1855b2d80:	0f 57 c0             	xorps  xmm0,xmm0
   1855b2d83:	0f 29 85 80 00 00 00 	movaps XMMWORD PTR [rbp+0x80],xmm0
   1855b2d8a:	0f 29 85 90 00 00 00 	movaps XMMWORD PTR [rbp+0x90],xmm0
   1855b2d91:	4c 8b 78 10          	mov    r15,QWORD PTR [rax+0x10]
   1855b2d95:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   1855b2d9a:	72 04                	jb     0x1855b2da0
   1855b2d9c:	4d 8b 24 24          	mov    r12,QWORD PTR [r12]
   1855b2da0:	4d 85 ff             	test   r15,r15
   1855b2da3:	0f 88 d8 2a 00 00    	js     0x1855b5881
   1855b2da9:	49 83 ff 0f          	cmp    r15,0xf
   1855b2dad:	0f 87 c7 0b 00 00    	ja     0x1855b397a
   1855b2db3:	4c 89 bd 90 00 00 00 	mov    QWORD PTR [rbp+0x90],r15
   1855b2dba:	48 c7 85 98 00 00 00 	mov    QWORD PTR [rbp+0x98],0xf
   1855b2dc1:	0f 00 00 00 
   1855b2dc5:	41 0f 10 04 24       	movups xmm0,XMMWORD PTR [r12]
   1855b2dca:	0f 29 85 80 00 00 00 	movaps XMMWORD PTR [rbp+0x80],xmm0
   1855b2dd1:	4d 85 ff             	test   r15,r15
   1855b2dd4:	0f 85 4d 22 00 00    	jne    0x1855b5027
   1855b2dda:	e9 24 18 00 00       	jmp    0x1855b4603
   1855b2ddf:	0f 28 05 ca 2d 79 03 	movaps xmm0,XMMWORD PTR [rip+0x3792dca]        # 0x188d45bb0
   1855b2de6:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   1855b2ded:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b2df4:	e8 f7 42 7b fc       	call   0x181d670f0
   1855b2df9:	48 8b 85 e0 00 00 00 	mov    rax,QWORD PTR [rbp+0xe0]
   1855b2e00:	c7 80 18 01 00 00 03 	mov    DWORD PTR [rax+0x118],0x3
   1855b2e07:	00 00 00 
   1855b2e0a:	48 89 f9             	mov    rcx,rdi
   1855b2e0d:	e8 ce 26 91 fd       	call   0x182ec54e0
   1855b2e12:	90                   	nop
   1855b2e13:	48 85 c0             	test   rax,rax
   1855b2e16:	0f 84 be 0b 00 00    	je     0x1855b39da
   1855b2e1c:	48 89 c1             	mov    rcx,rax
   1855b2e1f:	4c 89 ea             	mov    rdx,r13
   1855b2e22:	e8 79 35 00 00       	call   0x1855b63a0
   1855b2e27:	90                   	nop
   1855b2e28:	e9 15 05 00 00       	jmp    0x1855b3342
   1855b2e2d:	48 89 f9             	mov    rcx,rdi
   1855b2e30:	e8 cb 24 91 fd       	call   0x182ec5300
   1855b2e35:	48 89 c7             	mov    rdi,rax
   1855b2e38:	49 89 c7             	mov    r15,rax
   1855b2e3b:	0f 28 05 6e 2d 79 03 	movaps xmm0,XMMWORD PTR [rip+0x3792d6e]        # 0x188d45bb0
   1855b2e42:	0f 29 45 f0          	movaps XMMWORD PTR [rbp-0x10],xmm0
   1855b2e46:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b2e4a:	e8 a1 3a 97 fd       	call   0x182f268f0
   1855b2e4f:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1855b2e53:	c7 80 18 01 00 00 30 	mov    DWORD PTR [rax+0x118],0x30
   1855b2e5a:	00 00 00 
   1855b2e5d:	f2 0f 10 47 08       	movsd  xmm0,QWORD PTR [rdi+0x8]
   1855b2e62:	f2 0f 11 80 58 07 00 	movsd  QWORD PTR [rax+0x758],xmm0
   1855b2e69:	00 
   1855b2e6a:	f2 0f 10 07          	movsd  xmm0,QWORD PTR [rdi]
   1855b2e6e:	f2 0f 11 80 60 07 00 	movsd  QWORD PTR [rax+0x760],xmm0
   1855b2e75:	00 
   1855b2e76:	4c 8d 4f 18          	lea    r9,[rdi+0x18]
   1855b2e7a:	48 8d 98 70 07 00 00 	lea    rbx,[rax+0x770]
   1855b2e81:	4c 39 cb             	cmp    rbx,r9
   1855b2e84:	0f 84 e9 0e 00 00    	je     0x1855b3d73
   1855b2e8a:	4d 8b 77 28          	mov    r14,QWORD PTR [r15+0x28]
   1855b2e8e:	49 83 7f 30 10       	cmp    QWORD PTR [r15+0x30],0x10
   1855b2e93:	72 04                	jb     0x1855b2e99
   1855b2e95:	4d 8b 4f 18          	mov    r9,QWORD PTR [r15+0x18]
   1855b2e99:	48 8b 88 88 07 00 00 	mov    rcx,QWORD PTR [rax+0x788]
   1855b2ea0:	49 39 ce             	cmp    r14,rcx
   1855b2ea3:	0f 86 a7 0e 00 00    	jbe    0x1855b3d50
   1855b2ea9:	48 89 d9             	mov    rcx,rbx
   1855b2eac:	4c 89 f2             	mov    rdx,r14
   1855b2eaf:	e8 9c b2 a8 fa       	call   0x18003e150
   1855b2eb4:	90                   	nop
   1855b2eb5:	e9 b9 0e 00 00       	jmp    0x1855b3d73
   1855b2eba:	0f 28 05 ef 2c 79 03 	movaps xmm0,XMMWORD PTR [rip+0x3792cef]        # 0x188d45bb0
   1855b2ec1:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   1855b2ec8:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b2ecf:	e8 fc 38 97 fd       	call   0x182f267d0
   1855b2ed4:	48 8b 85 e0 00 00 00 	mov    rax,QWORD PTR [rbp+0xe0]
   1855b2edb:	c7 80 18 01 00 00 2b 	mov    DWORD PTR [rax+0x118],0x2b
   1855b2ee2:	00 00 00 
   1855b2ee5:	48 89 f9             	mov    rcx,rdi
   1855b2ee8:	e8 f3 25 91 fd       	call   0x182ec54e0
   1855b2eed:	90                   	nop
   1855b2eee:	48 85 c0             	test   rax,rax
   1855b2ef1:	0f 84 ae 0b 00 00    	je     0x1855b3aa5
   1855b2ef7:	48 89 c1             	mov    rcx,rax
   1855b2efa:	4c 89 ea             	mov    rdx,r13
   1855b2efd:	e8 9e 34 00 00       	call   0x1855b63a0
   1855b2f02:	90                   	nop
   1855b2f03:	e9 3a 04 00 00       	jmp    0x1855b3342
   1855b2f08:	0f 28 05 a1 2c 79 03 	movaps xmm0,XMMWORD PTR [rip+0x3792ca1]        # 0x188d45bb0
   1855b2f0f:	0f 29 45 f0          	movaps XMMWORD PTR [rbp-0x10],xmm0
   1855b2f13:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b2f17:	e8 54 1d 14 fb       	call   0x1806f4c70
   1855b2f1c:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1855b2f20:	c7 80 18 01 00 00 01 	mov    DWORD PTR [rax+0x118],0x1
   1855b2f27:	00 00 00 
   1855b2f2a:	48 89 f9             	mov    rcx,rdi
   1855b2f2d:	e8 0e 17 91 fd       	call   0x182ec4640
   1855b2f32:	90                   	nop
   1855b2f33:	48 8b 4d f0          	mov    rcx,QWORD PTR [rbp-0x10]
   1855b2f37:	48 8d 99 58 07 00 00 	lea    rbx,[rcx+0x758]
   1855b2f3e:	48 39 c3             	cmp    rbx,rax
   1855b2f41:	0f 84 3a 10 00 00    	je     0x1855b3f81
   1855b2f47:	4c 8b 70 10          	mov    r14,QWORD PTR [rax+0x10]
   1855b2f4b:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   1855b2f50:	72 03                	jb     0x1855b2f55
   1855b2f52:	48 8b 00             	mov    rax,QWORD PTR [rax]
   1855b2f55:	48 8b 91 70 07 00 00 	mov    rdx,QWORD PTR [rcx+0x770]
   1855b2f5c:	49 39 d6             	cmp    r14,rdx
   1855b2f5f:	0f 86 f9 0f 00 00    	jbe    0x1855b3f5e
   1855b2f65:	48 89 d9             	mov    rcx,rbx
   1855b2f68:	4c 89 f2             	mov    rdx,r14
   1855b2f6b:	49 89 c1             	mov    r9,rax
   1855b2f6e:	e8 dd b1 a8 fa       	call   0x18003e150
   1855b2f73:	90                   	nop
   1855b2f74:	e9 08 10 00 00       	jmp    0x1855b3f81
   1855b2f79:	4c 89 6d e8          	mov    QWORD PTR [rbp-0x18],r13
   1855b2f7d:	48 89 f9             	mov    rcx,rdi
   1855b2f80:	e8 2b 25 91 fd       	call   0x182ec54b0
   1855b2f85:	49 89 c6             	mov    r14,rax
   1855b2f88:	48 89 c3             	mov    rbx,rax
   1855b2f8b:	0f 28 05 1e 2c 79 03 	movaps xmm0,XMMWORD PTR [rip+0x3792c1e]        # 0x188d45bb0
   1855b2f92:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1855b2f99:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   1855b2fa0:	e8 8b e6 f2 fe       	call   0x1844e1630
   1855b2fa5:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b2fac:	48 b9 31 00 00 00 44 	movabs rcx,0x4400000031
   1855b2fb3:	00 00 00 
   1855b2fb6:	48 89 88 18 01 00 00 	mov    QWORD PTR [rax+0x118],rcx
   1855b2fbd:	4d 8d 8e d0 01 00 00 	lea    r9,[r14+0x1d0]
   1855b2fc4:	4c 8d b8 58 07 00 00 	lea    r15,[rax+0x758]
   1855b2fcb:	4d 39 cf             	cmp    r15,r9
   1855b2fce:	0f 84 0a 0e 00 00    	je     0x1855b3dde
   1855b2fd4:	4c 8b a3 e0 01 00 00 	mov    r12,QWORD PTR [rbx+0x1e0]
   1855b2fdb:	48 83 bb e8 01 00 00 	cmp    QWORD PTR [rbx+0x1e8],0x10
   1855b2fe2:	10 
   1855b2fe3:	72 07                	jb     0x1855b2fec
   1855b2fe5:	4c 8b 8b d0 01 00 00 	mov    r9,QWORD PTR [rbx+0x1d0]
   1855b2fec:	48 8b 88 70 07 00 00 	mov    rcx,QWORD PTR [rax+0x770]
   1855b2ff3:	49 39 cc             	cmp    r12,rcx
   1855b2ff6:	0f 86 bf 0d 00 00    	jbe    0x1855b3dbb
   1855b2ffc:	4c 89 f9             	mov    rcx,r15
   1855b2fff:	4c 89 e2             	mov    rdx,r12
   1855b3002:	e8 49 b1 a8 fa       	call   0x18003e150
   1855b3007:	90                   	nop
   1855b3008:	e9 d1 0d 00 00       	jmp    0x1855b3dde
   1855b300d:	48 89 f9             	mov    rcx,rdi
   1855b3010:	e8 cb 24 91 fd       	call   0x182ec54e0
   1855b3015:	48 85 c0             	test   rax,rax
   1855b3018:	75 11                	jne    0x1855b302b
   1855b301a:	48 89 f9             	mov    rcx,rdi
   1855b301d:	e8 be 24 91 fd       	call   0x182ec54e0
   1855b3022:	48 85 c0             	test   rax,rax
   1855b3025:	0f 84 2c 1e 00 00    	je     0x1855b4e57
   1855b302b:	48 89 c3             	mov    rbx,rax
   1855b302e:	0f 28 05 7b 2b 79 03 	movaps xmm0,XMMWORD PTR [rip+0x3792b7b]        # 0x188d45bb0
   1855b3035:	0f 29 45 f0          	movaps XMMWORD PTR [rbp-0x10],xmm0
   1855b3039:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b303d:	e8 ae 7a 00 00       	call   0x1855baaf0
   1855b3042:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1855b3046:	48 b9 31 00 00 00 5c 	movabs rcx,0x5c00000031
   1855b304d:	00 00 00 
   1855b3050:	48 89 88 18 01 00 00 	mov    QWORD PTR [rax+0x118],rcx
   1855b3057:	48 89 f9             	mov    rcx,rdi
   1855b305a:	e8 c1 17 91 fd       	call   0x182ec4820
   1855b305f:	90                   	nop
   1855b3060:	48 8b 4d f0          	mov    rcx,QWORD PTR [rbp-0x10]
   1855b3064:	48 8d b9 98 07 00 00 	lea    rdi,[rcx+0x798]
   1855b306b:	48 39 c7             	cmp    rdi,rax
   1855b306e:	0f 84 20 11 00 00    	je     0x1855b4194
   1855b3074:	4c 8b 70 10          	mov    r14,QWORD PTR [rax+0x10]
   1855b3078:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   1855b307d:	72 03                	jb     0x1855b3082
   1855b307f:	48 8b 00             	mov    rax,QWORD PTR [rax]
   1855b3082:	48 8b 91 b0 07 00 00 	mov    rdx,QWORD PTR [rcx+0x7b0]
   1855b3089:	49 39 d6             	cmp    r14,rdx
   1855b308c:	0f 86 df 10 00 00    	jbe    0x1855b4171
   1855b3092:	48 89 f9             	mov    rcx,rdi
   1855b3095:	4c 89 f2             	mov    rdx,r14
   1855b3098:	49 89 c1             	mov    r9,rax
   1855b309b:	e8 b0 b0 a8 fa       	call   0x18003e150
   1855b30a0:	90                   	nop
   1855b30a1:	e9 ee 10 00 00       	jmp    0x1855b4194
   1855b30a6:	0f 28 05 03 2b 79 03 	movaps xmm0,XMMWORD PTR [rip+0x3792b03]        # 0x188d45bb0
   1855b30ad:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1855b30b4:	48 89 f9             	mov    rcx,rdi
   1855b30b7:	e8 e4 1c 91 fd       	call   0x182ec4da0
   1855b30bc:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   1855b30c3:	48 89 c2             	mov    rdx,rax
   1855b30c6:	41 b8 13 00 00 00    	mov    r8d,0x13
   1855b30cc:	e8 bf bf 00 00       	call   0x1855bf090
   1855b30d1:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b30d8:	48 85 c0             	test   rax,rax
   1855b30db:	0f 84 df 08 00 00    	je     0x1855b39c0
   1855b30e1:	48 8b 8d 08 01 00 00 	mov    rcx,QWORD PTR [rbp+0x108]
   1855b30e8:	48 85 c9             	test   rcx,rcx
   1855b30eb:	0f 84 61 18 00 00    	je     0x1855b4952
   1855b30f1:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   1855b30f5:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b30fc:	48 8b 8d 08 01 00 00 	mov    rcx,QWORD PTR [rbp+0x108]
   1855b3103:	e9 4c 18 00 00       	jmp    0x1855b4954
   1855b3108:	b9 04 00 00 00       	mov    ecx,0x4
   1855b310d:	e8 ce 9c ab fa       	call   0x18006cde0
   1855b3112:	bb 05 00 00 00       	mov    ebx,0x5
   1855b3117:	85 c0                	test   eax,eax
   1855b3119:	0f 84 46 27 00 00    	je     0x1855b5865
   1855b311f:	48 8d b5 80 00 00 00 	lea    rsi,[rbp+0x80]
   1855b3126:	48 89 f1             	mov    rcx,rsi
   1855b3129:	e8 e2 9d ab fa       	call   0x18006cf10
   1855b312e:	48 83 bd 98 00 00 00 	cmp    QWORD PTR [rbp+0x98],0x10
   1855b3135:	10 
   1855b3136:	72 07                	jb     0x1855b313f
   1855b3138:	48 8b b5 80 00 00 00 	mov    rsi,QWORD PTR [rbp+0x80]
   1855b313f:	48 8d 05 9a e7 26 04 	lea    rax,[rip+0x426e79a]        # 0x1898218e0
   1855b3146:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b314b:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b3152:	00 00 
   1855b3154:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b3159:	c7 44 24 28 5f 00 00 	mov    DWORD PTR [rsp+0x28],0x5f
   1855b3160:	00 
   1855b3161:	4c 8d 0d d8 e7 26 04 	lea    r9,[rip+0x426e7d8]        # 0x189821940
   1855b3168:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b316c:	ba 04 00 00 00       	mov    edx,0x4
   1855b3171:	49 89 f0             	mov    r8,rsi
   1855b3174:	e8 f7 a0 ab fa       	call   0x18006d270
   1855b3179:	90                   	nop
   1855b317a:	0f 57 c0             	xorps  xmm0,xmm0
   1855b317d:	0f 29 85 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm0
   1855b3184:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   1855b318b:	0f 29 85 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm0
   1855b3192:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   1855b3199:	0f 29 85 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm0
   1855b31a0:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   1855b31a7:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   1855b31ae:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1855b31b5:	48 8d 15 fc e7 26 04 	lea    rdx,[rip+0x426e7fc]        # 0x1898219b8
   1855b31bc:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b31c0:	4c 8d 85 00 01 00 00 	lea    r8,[rbp+0x100]
   1855b31c7:	e8 44 a6 ab fa       	call   0x18006d810
   1855b31cc:	90                   	nop
   1855b31cd:	e9 80 0f 00 00       	jmp    0x1855b4152
   1855b31d2:	0f 28 05 d7 29 79 03 	movaps xmm0,XMMWORD PTR [rip+0x37929d7]        # 0x188d45bb0
   1855b31d9:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   1855b31e0:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b31e7:	e8 74 81 5f fd       	call   0x182bab360
   1855b31ec:	48 8b 85 e0 00 00 00 	mov    rax,QWORD PTR [rbp+0xe0]
   1855b31f3:	48 b9 31 00 00 00 06 	movabs rcx,0x600000031
   1855b31fa:	00 00 00 
   1855b31fd:	48 89 88 18 01 00 00 	mov    QWORD PTR [rax+0x118],rcx
   1855b3204:	48 89 f9             	mov    rcx,rdi
   1855b3207:	e8 d4 22 91 fd       	call   0x182ec54e0
   1855b320c:	90                   	nop
   1855b320d:	48 85 c0             	test   rax,rax
   1855b3210:	0f 84 5a 09 00 00    	je     0x1855b3b70
   1855b3216:	48 89 c1             	mov    rcx,rax
   1855b3219:	4c 89 ea             	mov    rdx,r13
   1855b321c:	e8 7f 31 00 00       	call   0x1855b63a0
   1855b3221:	90                   	nop
   1855b3222:	48 89 c3             	mov    rbx,rax
   1855b3225:	49 8b 45 00          	mov    rax,QWORD PTR [r13+0x0]
   1855b3229:	48 85 c0             	test   rax,rax
   1855b322c:	0f 84 e4 0a 00 00    	je     0x1855b3d16
   1855b3232:	48 83 b8 b8 01 00 00 	cmp    QWORD PTR [rax+0x1b8],0x0
   1855b3239:	00 
   1855b323a:	0f 85 d6 0a 00 00    	jne    0x1855b3d16
   1855b3240:	48 89 f9             	mov    rcx,rdi
   1855b3243:	e8 58 13 91 fd       	call   0x182ec45a0
   1855b3248:	90                   	nop
   1855b3249:	b9 a8 01 00 00       	mov    ecx,0x1a8
   1855b324e:	49 03 4d 00          	add    rcx,QWORD PTR [r13+0x0]
   1855b3252:	48 89 c2             	mov    rdx,rax
   1855b3255:	e8 c6 21 d9 fa       	call   0x180345420
   1855b325a:	90                   	nop
   1855b325b:	e9 b6 0a 00 00       	jmp    0x1855b3d16
   1855b3260:	48 89 f9             	mov    rcx,rdi
   1855b3263:	e8 78 22 91 fd       	call   0x182ec54e0
   1855b3268:	48 85 c0             	test   rax,rax
   1855b326b:	75 11                	jne    0x1855b327e
   1855b326d:	48 89 f9             	mov    rcx,rdi
   1855b3270:	e8 6b 22 91 fd       	call   0x182ec54e0
   1855b3275:	48 85 c0             	test   rax,rax
   1855b3278:	0f 84 a3 1c 00 00    	je     0x1855b4f21
   1855b327e:	48 89 c3             	mov    rbx,rax
   1855b3281:	0f 28 05 28 29 79 03 	movaps xmm0,XMMWORD PTR [rip+0x3792928]        # 0x188d45bb0
   1855b3288:	0f 29 45 f0          	movaps XMMWORD PTR [rbp-0x10],xmm0
   1855b328c:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b3290:	e8 5b 78 00 00       	call   0x1855baaf0
   1855b3295:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1855b3299:	48 b9 31 00 00 00 5d 	movabs rcx,0x5d00000031
   1855b32a0:	00 00 00 
   1855b32a3:	48 89 88 18 01 00 00 	mov    QWORD PTR [rax+0x118],rcx
   1855b32aa:	48 89 f9             	mov    rcx,rdi
   1855b32ad:	e8 6e 15 91 fd       	call   0x182ec4820
   1855b32b2:	90                   	nop
   1855b32b3:	48 8b 4d f0          	mov    rcx,QWORD PTR [rbp-0x10]
   1855b32b7:	48 8d b9 98 07 00 00 	lea    rdi,[rcx+0x798]
   1855b32be:	48 39 c7             	cmp    rdi,rax
   1855b32c1:	0f 84 44 0f 00 00    	je     0x1855b420b
   1855b32c7:	4c 8b 70 10          	mov    r14,QWORD PTR [rax+0x10]
   1855b32cb:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   1855b32d0:	72 03                	jb     0x1855b32d5
   1855b32d2:	48 8b 00             	mov    rax,QWORD PTR [rax]
   1855b32d5:	48 8b 91 b0 07 00 00 	mov    rdx,QWORD PTR [rcx+0x7b0]
   1855b32dc:	49 39 d6             	cmp    r14,rdx
   1855b32df:	0f 86 03 0f 00 00    	jbe    0x1855b41e8
   1855b32e5:	48 89 f9             	mov    rcx,rdi
   1855b32e8:	4c 89 f2             	mov    rdx,r14
   1855b32eb:	49 89 c1             	mov    r9,rax
   1855b32ee:	e8 5d ae a8 fa       	call   0x18003e150
   1855b32f3:	90                   	nop
   1855b32f4:	e9 12 0f 00 00       	jmp    0x1855b420b
   1855b32f9:	0f 28 05 b0 28 79 03 	movaps xmm0,XMMWORD PTR [rip+0x37928b0]        # 0x188d45bb0
   1855b3300:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   1855b3307:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b330e:	e8 bd 34 97 fd       	call   0x182f267d0
   1855b3313:	48 8b 85 e0 00 00 00 	mov    rax,QWORD PTR [rbp+0xe0]
   1855b331a:	c7 80 18 01 00 00 2b 	mov    DWORD PTR [rax+0x118],0x2b
   1855b3321:	00 00 00 
   1855b3324:	48 89 f9             	mov    rcx,rdi
   1855b3327:	e8 b4 21 91 fd       	call   0x182ec54e0
   1855b332c:	90                   	nop
   1855b332d:	48 85 c0             	test   rax,rax
   1855b3330:	0f 84 05 09 00 00    	je     0x1855b3c3b
   1855b3336:	48 89 c1             	mov    rcx,rax
   1855b3339:	4c 89 ea             	mov    rdx,r13
   1855b333c:	e8 5f 30 00 00       	call   0x1855b63a0
   1855b3341:	90                   	nop
   1855b3342:	48 89 c3             	mov    rbx,rax
   1855b3345:	48 8b b5 e8 00 00 00 	mov    rsi,QWORD PTR [rbp+0xe8]
   1855b334c:	48 85 f6             	test   rsi,rsi
   1855b334f:	0f 85 d1 09 00 00    	jne    0x1855b3d26
   1855b3355:	e9 0b 25 00 00       	jmp    0x1855b5865
   1855b335a:	48 83 fa 10          	cmp    rdx,0x10
   1855b335e:	72 03                	jb     0x1855b3363
   1855b3360:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b3363:	4c 89 b1 a8 07 00 00 	mov    QWORD PTR [rcx+0x7a8],r14
   1855b336a:	48 89 f9             	mov    rcx,rdi
   1855b336d:	48 89 c2             	mov    rdx,rax
   1855b3370:	4d 89 f0             	mov    r8,r14
   1855b3373:	e8 d8 0c f9 01       	call   0x187544050
   1855b3378:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b337d:	4c 8d 8b 90 01 00 00 	lea    r9,[rbx+0x190]
   1855b3384:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b338b:	48 8d b8 58 07 00 00 	lea    rdi,[rax+0x758]
   1855b3392:	4c 39 cf             	cmp    rdi,r9
   1855b3395:	74 55                	je     0x1855b33ec
   1855b3397:	4c 8b b3 a0 01 00 00 	mov    r14,QWORD PTR [rbx+0x1a0]
   1855b339e:	48 83 bb a8 01 00 00 	cmp    QWORD PTR [rbx+0x1a8],0x10
   1855b33a5:	10 
   1855b33a6:	72 07                	jb     0x1855b33af
   1855b33a8:	4c 8b 8b 90 01 00 00 	mov    r9,QWORD PTR [rbx+0x190]
   1855b33af:	48 8b 88 70 07 00 00 	mov    rcx,QWORD PTR [rax+0x770]
   1855b33b6:	49 39 ce             	cmp    r14,rcx
   1855b33b9:	76 0e                	jbe    0x1855b33c9
   1855b33bb:	48 89 f9             	mov    rcx,rdi
   1855b33be:	4c 89 f2             	mov    rdx,r14
   1855b33c1:	e8 8a ad a8 fa       	call   0x18003e150
   1855b33c6:	90                   	nop
   1855b33c7:	eb 23                	jmp    0x1855b33ec
   1855b33c9:	48 83 f9 10          	cmp    rcx,0x10
   1855b33cd:	72 03                	jb     0x1855b33d2
   1855b33cf:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b33d2:	4c 89 b0 68 07 00 00 	mov    QWORD PTR [rax+0x768],r14
   1855b33d9:	48 89 f9             	mov    rcx,rdi
   1855b33dc:	4c 89 ca             	mov    rdx,r9
   1855b33df:	4d 89 f0             	mov    r8,r14
   1855b33e2:	e8 69 0c f9 01       	call   0x187544050
   1855b33e7:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b33ec:	4c 8d 8b b0 01 00 00 	lea    r9,[rbx+0x1b0]
   1855b33f3:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b33fa:	48 8d b8 78 07 00 00 	lea    rdi,[rax+0x778]
   1855b3401:	4c 39 cf             	cmp    rdi,r9
   1855b3404:	74 55                	je     0x1855b345b
   1855b3406:	4c 8b b3 c0 01 00 00 	mov    r14,QWORD PTR [rbx+0x1c0]
   1855b340d:	48 83 bb c8 01 00 00 	cmp    QWORD PTR [rbx+0x1c8],0x10
   1855b3414:	10 
   1855b3415:	72 07                	jb     0x1855b341e
   1855b3417:	4c 8b 8b b0 01 00 00 	mov    r9,QWORD PTR [rbx+0x1b0]
   1855b341e:	48 8b 88 90 07 00 00 	mov    rcx,QWORD PTR [rax+0x790]
   1855b3425:	49 39 ce             	cmp    r14,rcx
   1855b3428:	76 0e                	jbe    0x1855b3438
   1855b342a:	48 89 f9             	mov    rcx,rdi
   1855b342d:	4c 89 f2             	mov    rdx,r14
   1855b3430:	e8 1b ad a8 fa       	call   0x18003e150
   1855b3435:	90                   	nop
   1855b3436:	eb 23                	jmp    0x1855b345b
   1855b3438:	48 83 f9 10          	cmp    rcx,0x10
   1855b343c:	72 03                	jb     0x1855b3441
   1855b343e:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b3441:	4c 89 b0 88 07 00 00 	mov    QWORD PTR [rax+0x788],r14
   1855b3448:	48 89 f9             	mov    rcx,rdi
   1855b344b:	4c 89 ca             	mov    rdx,r9
   1855b344e:	4d 89 f0             	mov    r8,r14
   1855b3451:	e8 fa 0b f9 01       	call   0x187544050
   1855b3456:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b345b:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b345f:	41 b8 02 00 00 00    	mov    r8d,0x2
   1855b3465:	48 89 da             	mov    rdx,rbx
   1855b3468:	e8 f3 cc fa fe       	call   0x184560160
   1855b346d:	90                   	nop
   1855b346e:	b9 20 01 00 00       	mov    ecx,0x120
   1855b3473:	48 03 8d 00 01 00 00 	add    rcx,QWORD PTR [rbp+0x100]
   1855b347a:	48 8d 7d f0          	lea    rdi,[rbp-0x10]
   1855b347e:	48 89 fa             	mov    rdx,rdi
   1855b3481:	e8 ba 81 ae fa       	call   0x18009b640
   1855b3486:	48 89 f9             	mov    rcx,rdi
   1855b3489:	e8 d2 45 a5 fa       	call   0x180007a60
   1855b348e:	4c 8d 8b d0 03 00 00 	lea    r9,[rbx+0x3d0]
   1855b3495:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b349c:	48 8d b8 e0 07 00 00 	lea    rdi,[rax+0x7e0]
   1855b34a3:	4c 39 cf             	cmp    rdi,r9
   1855b34a6:	74 55                	je     0x1855b34fd
   1855b34a8:	4c 8b b3 e0 03 00 00 	mov    r14,QWORD PTR [rbx+0x3e0]
   1855b34af:	48 83 bb e8 03 00 00 	cmp    QWORD PTR [rbx+0x3e8],0x10
   1855b34b6:	10 
   1855b34b7:	72 07                	jb     0x1855b34c0
   1855b34b9:	4c 8b 8b d0 03 00 00 	mov    r9,QWORD PTR [rbx+0x3d0]
   1855b34c0:	48 8b 88 f8 07 00 00 	mov    rcx,QWORD PTR [rax+0x7f8]
   1855b34c7:	49 39 ce             	cmp    r14,rcx
   1855b34ca:	76 0e                	jbe    0x1855b34da
   1855b34cc:	48 89 f9             	mov    rcx,rdi
   1855b34cf:	4c 89 f2             	mov    rdx,r14
   1855b34d2:	e8 79 ac a8 fa       	call   0x18003e150
   1855b34d7:	90                   	nop
   1855b34d8:	eb 23                	jmp    0x1855b34fd
   1855b34da:	48 83 f9 10          	cmp    rcx,0x10
   1855b34de:	72 03                	jb     0x1855b34e3
   1855b34e0:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b34e3:	4c 89 b0 f0 07 00 00 	mov    QWORD PTR [rax+0x7f0],r14
   1855b34ea:	48 89 f9             	mov    rcx,rdi
   1855b34ed:	4c 89 ca             	mov    rdx,r9
   1855b34f0:	4d 89 f0             	mov    r8,r14
   1855b34f3:	e8 58 0b f9 01       	call   0x187544050
   1855b34f8:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b34fd:	4c 8d 8b 10 04 00 00 	lea    r9,[rbx+0x410]
   1855b3504:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b350b:	48 8d b8 00 08 00 00 	lea    rdi,[rax+0x800]
   1855b3512:	4c 39 cf             	cmp    rdi,r9
   1855b3515:	74 55                	je     0x1855b356c
   1855b3517:	4c 8b b3 20 04 00 00 	mov    r14,QWORD PTR [rbx+0x420]
   1855b351e:	48 83 bb 28 04 00 00 	cmp    QWORD PTR [rbx+0x428],0x10
   1855b3525:	10 
   1855b3526:	72 07                	jb     0x1855b352f
   1855b3528:	4c 8b 8b 10 04 00 00 	mov    r9,QWORD PTR [rbx+0x410]
   1855b352f:	48 8b 88 18 08 00 00 	mov    rcx,QWORD PTR [rax+0x818]
   1855b3536:	49 39 ce             	cmp    r14,rcx
   1855b3539:	76 0e                	jbe    0x1855b3549
   1855b353b:	48 89 f9             	mov    rcx,rdi
   1855b353e:	4c 89 f2             	mov    rdx,r14
   1855b3541:	e8 0a ac a8 fa       	call   0x18003e150
   1855b3546:	90                   	nop
   1855b3547:	eb 23                	jmp    0x1855b356c
   1855b3549:	48 83 f9 10          	cmp    rcx,0x10
   1855b354d:	72 03                	jb     0x1855b3552
   1855b354f:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b3552:	4c 89 b0 10 08 00 00 	mov    QWORD PTR [rax+0x810],r14
   1855b3559:	48 89 f9             	mov    rcx,rdi
   1855b355c:	4c 89 ca             	mov    rdx,r9
   1855b355f:	4d 89 f0             	mov    r8,r14
   1855b3562:	e8 e9 0a f9 01       	call   0x187544050
   1855b3567:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b356c:	4c 8d 8b f0 03 00 00 	lea    r9,[rbx+0x3f0]
   1855b3573:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b357a:	48 8d b8 20 08 00 00 	lea    rdi,[rax+0x820]
   1855b3581:	4c 39 cf             	cmp    rdi,r9
   1855b3584:	74 55                	je     0x1855b35db
   1855b3586:	4c 8b b3 00 04 00 00 	mov    r14,QWORD PTR [rbx+0x400]
   1855b358d:	48 83 bb 08 04 00 00 	cmp    QWORD PTR [rbx+0x408],0x10
   1855b3594:	10 
   1855b3595:	72 07                	jb     0x1855b359e
   1855b3597:	4c 8b 8b f0 03 00 00 	mov    r9,QWORD PTR [rbx+0x3f0]
   1855b359e:	48 8b 88 38 08 00 00 	mov    rcx,QWORD PTR [rax+0x838]
   1855b35a5:	49 39 ce             	cmp    r14,rcx
   1855b35a8:	76 0e                	jbe    0x1855b35b8
   1855b35aa:	48 89 f9             	mov    rcx,rdi
   1855b35ad:	4c 89 f2             	mov    rdx,r14
   1855b35b0:	e8 9b ab a8 fa       	call   0x18003e150
   1855b35b5:	90                   	nop
   1855b35b6:	eb 23                	jmp    0x1855b35db
   1855b35b8:	48 83 f9 10          	cmp    rcx,0x10
   1855b35bc:	72 03                	jb     0x1855b35c1
   1855b35be:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b35c1:	4c 89 b0 30 08 00 00 	mov    QWORD PTR [rax+0x830],r14
   1855b35c8:	48 89 f9             	mov    rcx,rdi
   1855b35cb:	4c 89 ca             	mov    rdx,r9
   1855b35ce:	4d 89 f0             	mov    r8,r14
   1855b35d1:	e8 7a 0a f9 01       	call   0x187544050
   1855b35d6:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b35db:	4c 8d 8b a0 04 00 00 	lea    r9,[rbx+0x4a0]
   1855b35e2:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b35e9:	48 8d b8 40 08 00 00 	lea    rdi,[rax+0x840]
   1855b35f0:	4c 39 cf             	cmp    rdi,r9
   1855b35f3:	74 55                	je     0x1855b364a
   1855b35f5:	4c 8b b3 b0 04 00 00 	mov    r14,QWORD PTR [rbx+0x4b0]
   1855b35fc:	48 83 bb b8 04 00 00 	cmp    QWORD PTR [rbx+0x4b8],0x10
   1855b3603:	10 
   1855b3604:	72 07                	jb     0x1855b360d
   1855b3606:	4c 8b 8b a0 04 00 00 	mov    r9,QWORD PTR [rbx+0x4a0]
   1855b360d:	48 8b 88 58 08 00 00 	mov    rcx,QWORD PTR [rax+0x858]
   1855b3614:	49 39 ce             	cmp    r14,rcx
   1855b3617:	76 0e                	jbe    0x1855b3627
   1855b3619:	48 89 f9             	mov    rcx,rdi
   1855b361c:	4c 89 f2             	mov    rdx,r14
   1855b361f:	e8 2c ab a8 fa       	call   0x18003e150
   1855b3624:	90                   	nop
   1855b3625:	eb 23                	jmp    0x1855b364a
   1855b3627:	48 83 f9 10          	cmp    rcx,0x10
   1855b362b:	72 03                	jb     0x1855b3630
   1855b362d:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b3630:	4c 89 b0 50 08 00 00 	mov    QWORD PTR [rax+0x850],r14
   1855b3637:	48 89 f9             	mov    rcx,rdi
   1855b363a:	4c 89 ca             	mov    rdx,r9
   1855b363d:	4d 89 f0             	mov    r8,r14
   1855b3640:	e8 0b 0a f9 01       	call   0x187544050
   1855b3645:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b364a:	4c 8d 8b c0 04 00 00 	lea    r9,[rbx+0x4c0]
   1855b3651:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b3658:	48 8d b8 60 08 00 00 	lea    rdi,[rax+0x860]
   1855b365f:	4c 39 cf             	cmp    rdi,r9
   1855b3662:	74 55                	je     0x1855b36b9
   1855b3664:	4c 8b b3 d0 04 00 00 	mov    r14,QWORD PTR [rbx+0x4d0]
   1855b366b:	48 83 bb d8 04 00 00 	cmp    QWORD PTR [rbx+0x4d8],0x10
   1855b3672:	10 
   1855b3673:	72 07                	jb     0x1855b367c
   1855b3675:	4c 8b 8b c0 04 00 00 	mov    r9,QWORD PTR [rbx+0x4c0]
   1855b367c:	48 8b 88 78 08 00 00 	mov    rcx,QWORD PTR [rax+0x878]
   1855b3683:	49 39 ce             	cmp    r14,rcx
   1855b3686:	76 0e                	jbe    0x1855b3696
   1855b3688:	48 89 f9             	mov    rcx,rdi
   1855b368b:	4c 89 f2             	mov    rdx,r14
   1855b368e:	e8 bd aa a8 fa       	call   0x18003e150
   1855b3693:	90                   	nop
   1855b3694:	eb 23                	jmp    0x1855b36b9
   1855b3696:	48 83 f9 10          	cmp    rcx,0x10
   1855b369a:	72 03                	jb     0x1855b369f
   1855b369c:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b369f:	4c 89 b0 70 08 00 00 	mov    QWORD PTR [rax+0x870],r14
   1855b36a6:	48 89 f9             	mov    rcx,rdi
   1855b36a9:	4c 89 ca             	mov    rdx,r9
   1855b36ac:	4d 89 f0             	mov    r8,r14
   1855b36af:	e8 9c 09 f9 01       	call   0x187544050
   1855b36b4:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b36b9:	8b 8b f0 01 00 00    	mov    ecx,DWORD PTR [rbx+0x1f0]
   1855b36bf:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b36c6:	89 88 80 08 00 00    	mov    DWORD PTR [rax+0x880],ecx
   1855b36cc:	4c 8d 8b 40 02 00 00 	lea    r9,[rbx+0x240]
   1855b36d3:	48 8d b8 88 08 00 00 	lea    rdi,[rax+0x888]
   1855b36da:	4c 39 cf             	cmp    rdi,r9
   1855b36dd:	74 55                	je     0x1855b3734
   1855b36df:	4c 8b b3 50 02 00 00 	mov    r14,QWORD PTR [rbx+0x250]
   1855b36e6:	48 83 bb 58 02 00 00 	cmp    QWORD PTR [rbx+0x258],0x10
   1855b36ed:	10 
   1855b36ee:	72 07                	jb     0x1855b36f7
   1855b36f0:	4c 8b 8b 40 02 00 00 	mov    r9,QWORD PTR [rbx+0x240]
   1855b36f7:	48 8b 88 a0 08 00 00 	mov    rcx,QWORD PTR [rax+0x8a0]
   1855b36fe:	49 39 ce             	cmp    r14,rcx
   1855b3701:	76 0e                	jbe    0x1855b3711
   1855b3703:	48 89 f9             	mov    rcx,rdi
   1855b3706:	4c 89 f2             	mov    rdx,r14
   1855b3709:	e8 42 aa a8 fa       	call   0x18003e150
   1855b370e:	90                   	nop
   1855b370f:	eb 23                	jmp    0x1855b3734
   1855b3711:	48 83 f9 10          	cmp    rcx,0x10
   1855b3715:	72 03                	jb     0x1855b371a
   1855b3717:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b371a:	4c 89 b0 98 08 00 00 	mov    QWORD PTR [rax+0x898],r14
   1855b3721:	48 89 f9             	mov    rcx,rdi
   1855b3724:	4c 89 ca             	mov    rdx,r9
   1855b3727:	4d 89 f0             	mov    r8,r14
   1855b372a:	e8 21 09 f9 01       	call   0x187544050
   1855b372f:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b3734:	4c 8d 8b 60 02 00 00 	lea    r9,[rbx+0x260]
   1855b373b:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b3742:	48 8d b8 a8 08 00 00 	lea    rdi,[rax+0x8a8]
   1855b3749:	4c 39 cf             	cmp    rdi,r9
   1855b374c:	0f 84 a4 16 00 00    	je     0x1855b4df6
   1855b3752:	4c 8b b3 70 02 00 00 	mov    r14,QWORD PTR [rbx+0x270]
   1855b3759:	48 83 bb 78 02 00 00 	cmp    QWORD PTR [rbx+0x278],0x10
   1855b3760:	10 
   1855b3761:	72 07                	jb     0x1855b376a
   1855b3763:	4c 8b 8b 60 02 00 00 	mov    r9,QWORD PTR [rbx+0x260]
   1855b376a:	48 8b 88 c0 08 00 00 	mov    rcx,QWORD PTR [rax+0x8c0]
   1855b3771:	49 39 ce             	cmp    r14,rcx
   1855b3774:	76 11                	jbe    0x1855b3787
   1855b3776:	48 89 f9             	mov    rcx,rdi
   1855b3779:	4c 89 f2             	mov    rdx,r14
   1855b377c:	e8 cf a9 a8 fa       	call   0x18003e150
   1855b3781:	90                   	nop
   1855b3782:	e9 6f 16 00 00       	jmp    0x1855b4df6
   1855b3787:	48 83 f9 10          	cmp    rcx,0x10
   1855b378b:	72 03                	jb     0x1855b3790
   1855b378d:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b3790:	4c 89 b0 b8 08 00 00 	mov    QWORD PTR [rax+0x8b8],r14
   1855b3797:	48 89 f9             	mov    rcx,rdi
   1855b379a:	4c 89 ca             	mov    rdx,r9
   1855b379d:	4d 89 f0             	mov    r8,r14
   1855b37a0:	e8 ab 08 f9 01       	call   0x187544050
   1855b37a5:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b37aa:	48 8b 85 08 01 00 00 	mov    rax,QWORD PTR [rbp+0x108]
   1855b37b1:	48 85 c0             	test   rax,rax
   1855b37b4:	0f 85 4c 16 00 00    	jne    0x1855b4e06
   1855b37ba:	31 c0                	xor    eax,eax
   1855b37bc:	e9 50 16 00 00       	jmp    0x1855b4e11
   1855b37c1:	b9 04 00 00 00       	mov    ecx,0x4
   1855b37c6:	e8 15 96 ab fa       	call   0x18006cde0
   1855b37cb:	85 c0                	test   eax,eax
   1855b37cd:	0f 84 c3 00 00 00    	je     0x1855b3896
   1855b37d3:	48 8d 9d 80 00 00 00 	lea    rbx,[rbp+0x80]
   1855b37da:	48 89 d9             	mov    rcx,rbx
   1855b37dd:	e8 2e 97 ab fa       	call   0x18006cf10
   1855b37e2:	48 83 bd 98 00 00 00 	cmp    QWORD PTR [rbp+0x98],0x10
   1855b37e9:	10 
   1855b37ea:	72 07                	jb     0x1855b37f3
   1855b37ec:	48 8b 9d 80 00 00 00 	mov    rbx,QWORD PTR [rbp+0x80]
   1855b37f3:	48 8d 05 e6 e0 26 04 	lea    rax,[rip+0x426e0e6]        # 0x1898218e0
   1855b37fa:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b37ff:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b3806:	00 00 
   1855b3808:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b380d:	c7 44 24 28 36 01 00 	mov    DWORD PTR [rsp+0x28],0x136
   1855b3814:	00 
   1855b3815:	4c 8d 0d 24 e1 26 04 	lea    r9,[rip+0x426e124]        # 0x189821940
   1855b381c:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b3820:	ba 04 00 00 00       	mov    edx,0x4
   1855b3825:	49 89 d8             	mov    r8,rbx
   1855b3828:	e8 43 9a ab fa       	call   0x18006d270
   1855b382d:	90                   	nop
   1855b382e:	0f 57 c0             	xorps  xmm0,xmm0
   1855b3831:	0f 29 85 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm0
   1855b3838:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   1855b383f:	0f 29 85 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm0
   1855b3846:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   1855b384d:	0f 29 85 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm0
   1855b3854:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   1855b385b:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   1855b3862:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1855b3869:	48 8d 15 d8 e2 26 04 	lea    rdx,[rip+0x426e2d8]        # 0x189821b48
   1855b3870:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b3874:	4c 8d 85 00 01 00 00 	lea    r8,[rbp+0x100]
   1855b387b:	e8 90 9f ab fa       	call   0x18006d810
   1855b3880:	90                   	nop
   1855b3881:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b3885:	e8 e6 9a ab fa       	call   0x18006d370
   1855b388a:	48 8d 8d 80 00 00 00 	lea    rcx,[rbp+0x80]
   1855b3891:	e8 7a e7 a4 fa       	call   0x180002010
   1855b3896:	4c 89 6d e8          	mov    QWORD PTR [rbp-0x18],r13
   1855b389a:	0f 28 05 0f 23 79 03 	movaps xmm0,XMMWORD PTR [rip+0x379230f]        # 0x188d45bb0
   1855b38a1:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1855b38a8:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   1855b38af:	e8 bc 13 14 fb       	call   0x1806f4c70
   1855b38b4:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b38bb:	c7 80 18 01 00 00 01 	mov    DWORD PTR [rax+0x118],0x1
   1855b38c2:	00 00 00 
   1855b38c5:	48 89 f9             	mov    rcx,rdi
   1855b38c8:	e8 d3 0c 91 fd       	call   0x182ec45a0
   1855b38cd:	90                   	nop
   1855b38ce:	48 89 c7             	mov    rdi,rax
   1855b38d1:	e8 0a 1a b2 fa       	call   0x1800d52e0
   1855b38d6:	90                   	nop
   1855b38d7:	48 89 c3             	mov    rbx,rax
   1855b38da:	48 89 c1             	mov    rcx,rax
   1855b38dd:	e8 be 0c f7 01       	call   0x1875245a0
   1855b38e2:	49 89 c7             	mov    r15,rax
   1855b38e5:	4c 8b 77 10          	mov    r14,QWORD PTR [rdi+0x10]
   1855b38e9:	49 bd ff ff ff ff ff 	movabs r13,0x7fffffffffffffff
   1855b38f0:	ff ff 7f 
   1855b38f3:	4c 89 f0             	mov    rax,r14
   1855b38f6:	4c 31 e8             	xor    rax,r13
   1855b38f9:	4c 39 f8             	cmp    rax,r15
   1855b38fc:	0f 82 8b 1f 00 00    	jb     0x1855b588d
   1855b3902:	48 8b 0f             	mov    rcx,QWORD PTR [rdi]
   1855b3905:	48 8b 57 18          	mov    rdx,QWORD PTR [rdi+0x18]
   1855b3909:	0f 57 c0             	xorps  xmm0,xmm0
   1855b390c:	0f 29 45 f0          	movaps XMMWORD PTR [rbp-0x10],xmm0
   1855b3910:	4b 8d 34 3e          	lea    rsi,[r14+r15*1]
   1855b3914:	48 83 fe 10          	cmp    rsi,0x10
   1855b3918:	0f 82 25 10 00 00    	jb     0x1855b4943
   1855b391e:	48 85 f6             	test   rsi,rsi
   1855b3921:	48 89 8d d8 00 00 00 	mov    QWORD PTR [rbp+0xd8],rcx
   1855b3928:	48 89 55 e0          	mov    QWORD PTR [rbp-0x20],rdx
   1855b392c:	78 21                	js     0x1855b394f
   1855b392e:	48 89 f0             	mov    rax,rsi
   1855b3931:	48 83 c8 0f          	or     rax,0xf
   1855b3935:	48 83 f8 17          	cmp    rax,0x17
   1855b3939:	41 bd 16 00 00 00    	mov    r13d,0x16
   1855b393f:	4c 0f 43 e8          	cmovae r13,rax
   1855b3943:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1855b3949:	0f 82 03 1e 00 00    	jb     0x1855b5752
   1855b394f:	49 8d 4d 28          	lea    rcx,[r13+0x28]
   1855b3953:	e8 44 7f ef 01       	call   0x1874ab89c
   1855b3958:	90                   	nop
   1855b3959:	49 89 c4             	mov    r12,rax
   1855b395c:	48 85 c0             	test   rax,rax
   1855b395f:	0f 84 17 1f 00 00    	je     0x1855b587c
   1855b3965:	4c 89 e0             	mov    rax,r12
   1855b3968:	49 83 c4 27          	add    r12,0x27
   1855b396c:	49 83 e4 e0          	and    r12,0xffffffffffffffe0
   1855b3970:	49 89 44 24 f8       	mov    QWORD PTR [r12-0x8],rax
   1855b3975:	e9 e5 1d 00 00       	jmp    0x1855b575f
   1855b397a:	4c 89 f8             	mov    rax,r15
   1855b397d:	48 83 c8 0f          	or     rax,0xf
   1855b3981:	48 83 f8 17          	cmp    rax,0x17
   1855b3985:	be 16 00 00 00       	mov    esi,0x16
   1855b398a:	48 0f 43 f0          	cmovae rsi,rax
   1855b398e:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1855b3994:	0f 82 2a 0c 00 00    	jb     0x1855b45c4
   1855b399a:	48 8d 4e 28          	lea    rcx,[rsi+0x28]
   1855b399e:	e8 f9 7e ef 01       	call   0x1874ab89c
   1855b39a3:	48 85 c0             	test   rax,rax
   1855b39a6:	0f 84 d0 1e 00 00    	je     0x1855b587c
   1855b39ac:	48 89 c1             	mov    rcx,rax
   1855b39af:	48 83 c0 27          	add    rax,0x27
   1855b39b3:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   1855b39b7:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   1855b39bb:	e9 0d 0c 00 00       	jmp    0x1855b45cd
   1855b39c0:	bb 01 00 00 00       	mov    ebx,0x1
   1855b39c5:	48 8b b5 08 01 00 00 	mov    rsi,QWORD PTR [rbp+0x108]
   1855b39cc:	48 85 f6             	test   rsi,rsi
   1855b39cf:	0f 85 51 03 00 00    	jne    0x1855b3d26
   1855b39d5:	e9 8b 1e 00 00       	jmp    0x1855b5865
   1855b39da:	b9 04 00 00 00       	mov    ecx,0x4
   1855b39df:	e8 fc 93 ab fa       	call   0x18006cde0
   1855b39e4:	bb 01 00 00 00       	mov    ebx,0x1
   1855b39e9:	85 c0                	test   eax,eax
   1855b39eb:	0f 84 25 03 00 00    	je     0x1855b3d16
   1855b39f1:	48 8d b5 80 00 00 00 	lea    rsi,[rbp+0x80]
   1855b39f8:	48 89 f1             	mov    rcx,rsi
   1855b39fb:	e8 10 95 ab fa       	call   0x18006cf10
   1855b3a00:	90                   	nop
   1855b3a01:	48 83 bd 98 00 00 00 	cmp    QWORD PTR [rbp+0x98],0x10
   1855b3a08:	10 
   1855b3a09:	72 07                	jb     0x1855b3a12
   1855b3a0b:	48 8b b5 80 00 00 00 	mov    rsi,QWORD PTR [rbp+0x80]
   1855b3a12:	48 8d 05 c7 de 26 04 	lea    rax,[rip+0x426dec7]        # 0x1898218e0
   1855b3a19:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b3a1e:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b3a25:	00 00 
   1855b3a27:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b3a2c:	c7 44 24 28 58 00 00 	mov    DWORD PTR [rsp+0x28],0x58
   1855b3a33:	00 
   1855b3a34:	4c 8d 0d 05 df 26 04 	lea    r9,[rip+0x426df05]        # 0x189821940
   1855b3a3b:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b3a3f:	ba 04 00 00 00       	mov    edx,0x4
   1855b3a44:	49 89 f0             	mov    r8,rsi
   1855b3a47:	e8 24 98 ab fa       	call   0x18006d270
   1855b3a4c:	90                   	nop
   1855b3a4d:	0f 57 c0             	xorps  xmm0,xmm0
   1855b3a50:	0f 29 85 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm0
   1855b3a57:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   1855b3a5e:	0f 29 85 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm0
   1855b3a65:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   1855b3a6c:	0f 29 85 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm0
   1855b3a73:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   1855b3a7a:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   1855b3a81:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1855b3a88:	48 8d 15 f9 df 26 04 	lea    rdx,[rip+0x426dff9]        # 0x189821a88
   1855b3a8f:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b3a93:	4c 8d 85 00 01 00 00 	lea    r8,[rbp+0x100]
   1855b3a9a:	e8 71 9d ab fa       	call   0x18006d810
   1855b3a9f:	90                   	nop
   1855b3aa0:	e9 5c 02 00 00       	jmp    0x1855b3d01
   1855b3aa5:	b9 04 00 00 00       	mov    ecx,0x4
   1855b3aaa:	e8 31 93 ab fa       	call   0x18006cde0
   1855b3aaf:	bb 01 00 00 00       	mov    ebx,0x1
   1855b3ab4:	85 c0                	test   eax,eax
   1855b3ab6:	0f 84 5a 02 00 00    	je     0x1855b3d16
   1855b3abc:	48 8d b5 80 00 00 00 	lea    rsi,[rbp+0x80]
   1855b3ac3:	48 89 f1             	mov    rcx,rsi
   1855b3ac6:	e8 45 94 ab fa       	call   0x18006cf10
   1855b3acb:	90                   	nop
   1855b3acc:	48 83 bd 98 00 00 00 	cmp    QWORD PTR [rbp+0x98],0x10
   1855b3ad3:	10 
   1855b3ad4:	72 07                	jb     0x1855b3add
   1855b3ad6:	48 8b b5 80 00 00 00 	mov    rsi,QWORD PTR [rbp+0x80]
   1855b3add:	48 8d 05 fc dd 26 04 	lea    rax,[rip+0x426ddfc]        # 0x1898218e0
   1855b3ae4:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b3ae9:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b3af0:	00 00 
   1855b3af2:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b3af7:	c7 44 24 28 67 00 00 	mov    DWORD PTR [rsp+0x28],0x67
   1855b3afe:	00 
   1855b3aff:	4c 8d 0d 3a de 26 04 	lea    r9,[rip+0x426de3a]        # 0x189821940
   1855b3b06:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b3b0a:	ba 04 00 00 00       	mov    edx,0x4
   1855b3b0f:	49 89 f0             	mov    r8,rsi
   1855b3b12:	e8 59 97 ab fa       	call   0x18006d270
   1855b3b17:	90                   	nop
   1855b3b18:	0f 57 c0             	xorps  xmm0,xmm0
   1855b3b1b:	0f 29 85 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm0
   1855b3b22:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   1855b3b29:	0f 29 85 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm0
   1855b3b30:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   1855b3b37:	0f 29 85 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm0
   1855b3b3e:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   1855b3b45:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   1855b3b4c:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1855b3b53:	48 8d 15 2e df 26 04 	lea    rdx,[rip+0x426df2e]        # 0x189821a88
   1855b3b5a:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b3b5e:	4c 8d 85 00 01 00 00 	lea    r8,[rbp+0x100]
   1855b3b65:	e8 a6 9c ab fa       	call   0x18006d810
   1855b3b6a:	90                   	nop
   1855b3b6b:	e9 91 01 00 00       	jmp    0x1855b3d01
   1855b3b70:	b9 04 00 00 00       	mov    ecx,0x4
   1855b3b75:	e8 66 92 ab fa       	call   0x18006cde0
   1855b3b7a:	bb 01 00 00 00       	mov    ebx,0x1
   1855b3b7f:	85 c0                	test   eax,eax
   1855b3b81:	0f 84 8f 01 00 00    	je     0x1855b3d16
   1855b3b87:	48 8d b5 80 00 00 00 	lea    rsi,[rbp+0x80]
   1855b3b8e:	48 89 f1             	mov    rcx,rsi
   1855b3b91:	e8 7a 93 ab fa       	call   0x18006cf10
   1855b3b96:	90                   	nop
   1855b3b97:	48 83 bd 98 00 00 00 	cmp    QWORD PTR [rbp+0x98],0x10
   1855b3b9e:	10 
   1855b3b9f:	72 07                	jb     0x1855b3ba8
   1855b3ba1:	48 8b b5 80 00 00 00 	mov    rsi,QWORD PTR [rbp+0x80]
   1855b3ba8:	48 8d 05 31 dd 26 04 	lea    rax,[rip+0x426dd31]        # 0x1898218e0
   1855b3baf:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b3bb4:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b3bbb:	00 00 
   1855b3bbd:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b3bc2:	c7 44 24 28 0e 01 00 	mov    DWORD PTR [rsp+0x28],0x10e
   1855b3bc9:	00 
   1855b3bca:	4c 8d 0d 6f dd 26 04 	lea    r9,[rip+0x426dd6f]        # 0x189821940
   1855b3bd1:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b3bd5:	ba 04 00 00 00       	mov    edx,0x4
   1855b3bda:	49 89 f0             	mov    r8,rsi
   1855b3bdd:	e8 8e 96 ab fa       	call   0x18006d270
   1855b3be2:	90                   	nop
   1855b3be3:	0f 57 c0             	xorps  xmm0,xmm0
   1855b3be6:	0f 29 85 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm0
   1855b3bed:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   1855b3bf4:	0f 29 85 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm0
   1855b3bfb:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   1855b3c02:	0f 29 85 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm0
   1855b3c09:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   1855b3c10:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   1855b3c17:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1855b3c1e:	48 8d 15 63 de 26 04 	lea    rdx,[rip+0x426de63]        # 0x189821a88
   1855b3c25:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b3c29:	4c 8d 85 00 01 00 00 	lea    r8,[rbp+0x100]
   1855b3c30:	e8 db 9b ab fa       	call   0x18006d810
   1855b3c35:	90                   	nop
   1855b3c36:	e9 c6 00 00 00       	jmp    0x1855b3d01
   1855b3c3b:	b9 04 00 00 00       	mov    ecx,0x4
   1855b3c40:	e8 9b 91 ab fa       	call   0x18006cde0
   1855b3c45:	bb 01 00 00 00       	mov    ebx,0x1
   1855b3c4a:	85 c0                	test   eax,eax
   1855b3c4c:	0f 84 c4 00 00 00    	je     0x1855b3d16
   1855b3c52:	48 8d b5 80 00 00 00 	lea    rsi,[rbp+0x80]
   1855b3c59:	48 89 f1             	mov    rcx,rsi
   1855b3c5c:	e8 af 92 ab fa       	call   0x18006cf10
   1855b3c61:	90                   	nop
   1855b3c62:	48 83 bd 98 00 00 00 	cmp    QWORD PTR [rbp+0x98],0x10
   1855b3c69:	10 
   1855b3c6a:	72 07                	jb     0x1855b3c73
   1855b3c6c:	48 8b b5 80 00 00 00 	mov    rsi,QWORD PTR [rbp+0x80]
   1855b3c73:	48 8d 05 66 dc 26 04 	lea    rax,[rip+0x426dc66]        # 0x1898218e0
   1855b3c7a:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b3c7f:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b3c86:	00 00 
   1855b3c88:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b3c8d:	c7 44 24 28 72 00 00 	mov    DWORD PTR [rsp+0x28],0x72
   1855b3c94:	00 
   1855b3c95:	4c 8d 0d a4 dc 26 04 	lea    r9,[rip+0x426dca4]        # 0x189821940
   1855b3c9c:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b3ca0:	ba 04 00 00 00       	mov    edx,0x4
   1855b3ca5:	49 89 f0             	mov    r8,rsi
   1855b3ca8:	e8 c3 95 ab fa       	call   0x18006d270
   1855b3cad:	90                   	nop
   1855b3cae:	0f 57 c0             	xorps  xmm0,xmm0
   1855b3cb1:	0f 29 85 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm0
   1855b3cb8:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   1855b3cbf:	0f 29 85 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm0
   1855b3cc6:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   1855b3ccd:	0f 29 85 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm0
   1855b3cd4:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   1855b3cdb:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   1855b3ce2:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1855b3ce9:	48 8d 15 98 dd 26 04 	lea    rdx,[rip+0x426dd98]        # 0x189821a88
   1855b3cf0:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b3cf4:	4c 8d 85 00 01 00 00 	lea    r8,[rbp+0x100]
   1855b3cfb:	e8 10 9b ab fa       	call   0x18006d810
   1855b3d00:	90                   	nop
   1855b3d01:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b3d05:	e8 66 96 ab fa       	call   0x18006d370
   1855b3d0a:	48 8d 8d 80 00 00 00 	lea    rcx,[rbp+0x80]
   1855b3d11:	e8 fa e2 a4 fa       	call   0x180002010
   1855b3d16:	48 8b b5 e8 00 00 00 	mov    rsi,QWORD PTR [rbp+0xe8]
   1855b3d1d:	48 85 f6             	test   rsi,rsi
   1855b3d20:	0f 84 3f 1b 00 00    	je     0x1855b5865
   1855b3d26:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1855b3d2a:	0f 85 35 1b 00 00    	jne    0x1855b5865
   1855b3d30:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b3d33:	48 89 f1             	mov    rcx,rsi
   1855b3d36:	ff 10                	call   QWORD PTR [rax]
   1855b3d38:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1855b3d3c:	0f 85 23 1b 00 00    	jne    0x1855b5865
   1855b3d42:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b3d45:	48 89 f1             	mov    rcx,rsi
   1855b3d48:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b3d4b:	e9 15 1b 00 00       	jmp    0x1855b5865
   1855b3d50:	48 83 f9 10          	cmp    rcx,0x10
   1855b3d54:	72 03                	jb     0x1855b3d59
   1855b3d56:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b3d59:	4c 89 b0 80 07 00 00 	mov    QWORD PTR [rax+0x780],r14
   1855b3d60:	48 89 d9             	mov    rcx,rbx
   1855b3d63:	4c 89 ca             	mov    rdx,r9
   1855b3d66:	4d 89 f0             	mov    r8,r14
   1855b3d69:	e8 e2 02 f9 01       	call   0x187544050
   1855b3d6e:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b3d73:	4c 8d 4f 38          	lea    r9,[rdi+0x38]
   1855b3d77:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1855b3d7b:	48 8d 98 90 07 00 00 	lea    rbx,[rax+0x790]
   1855b3d82:	4c 39 cb             	cmp    rbx,r9
   1855b3d85:	0f 84 c9 00 00 00    	je     0x1855b3e54
   1855b3d8b:	4d 8b 77 48          	mov    r14,QWORD PTR [r15+0x48]
   1855b3d8f:	49 83 7f 50 10       	cmp    QWORD PTR [r15+0x50],0x10
   1855b3d94:	72 04                	jb     0x1855b3d9a
   1855b3d96:	4d 8b 4f 38          	mov    r9,QWORD PTR [r15+0x38]
   1855b3d9a:	48 8b 88 a8 07 00 00 	mov    rcx,QWORD PTR [rax+0x7a8]
   1855b3da1:	49 39 ce             	cmp    r14,rcx
   1855b3da4:	0f 86 87 00 00 00    	jbe    0x1855b3e31
   1855b3daa:	48 89 d9             	mov    rcx,rbx
   1855b3dad:	4c 89 f2             	mov    rdx,r14
   1855b3db0:	e8 9b a3 a8 fa       	call   0x18003e150
   1855b3db5:	90                   	nop
   1855b3db6:	e9 99 00 00 00       	jmp    0x1855b3e54
   1855b3dbb:	48 83 f9 10          	cmp    rcx,0x10
   1855b3dbf:	72 03                	jb     0x1855b3dc4
   1855b3dc1:	4d 8b 3f             	mov    r15,QWORD PTR [r15]
   1855b3dc4:	4c 89 a0 68 07 00 00 	mov    QWORD PTR [rax+0x768],r12
   1855b3dcb:	4c 89 f9             	mov    rcx,r15
   1855b3dce:	4c 89 ca             	mov    rdx,r9
   1855b3dd1:	4d 89 e0             	mov    r8,r12
   1855b3dd4:	e8 77 02 f9 01       	call   0x187544050
   1855b3dd9:	43 c6 04 27 00       	mov    BYTE PTR [r15+r12*1],0x0
   1855b3dde:	4d 8d 8e f0 01 00 00 	lea    r9,[r14+0x1f0]
   1855b3de5:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b3dec:	4c 8d b8 78 07 00 00 	lea    r15,[rax+0x778]
   1855b3df3:	4d 39 cf             	cmp    r15,r9
   1855b3df6:	0f 84 c6 00 00 00    	je     0x1855b3ec2
   1855b3dfc:	4c 8b a3 00 02 00 00 	mov    r12,QWORD PTR [rbx+0x200]
   1855b3e03:	48 83 bb 08 02 00 00 	cmp    QWORD PTR [rbx+0x208],0x10
   1855b3e0a:	10 
   1855b3e0b:	72 07                	jb     0x1855b3e14
   1855b3e0d:	4c 8b 8b f0 01 00 00 	mov    r9,QWORD PTR [rbx+0x1f0]
   1855b3e14:	48 8b 88 90 07 00 00 	mov    rcx,QWORD PTR [rax+0x790]
   1855b3e1b:	49 39 cc             	cmp    r12,rcx
   1855b3e1e:	76 7f                	jbe    0x1855b3e9f
   1855b3e20:	4c 89 f9             	mov    rcx,r15
   1855b3e23:	4c 89 e2             	mov    rdx,r12
   1855b3e26:	e8 25 a3 a8 fa       	call   0x18003e150
   1855b3e2b:	90                   	nop
   1855b3e2c:	e9 91 00 00 00       	jmp    0x1855b3ec2
   1855b3e31:	48 83 f9 10          	cmp    rcx,0x10
   1855b3e35:	72 03                	jb     0x1855b3e3a
   1855b3e37:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b3e3a:	4c 89 b0 a0 07 00 00 	mov    QWORD PTR [rax+0x7a0],r14
   1855b3e41:	48 89 d9             	mov    rcx,rbx
   1855b3e44:	4c 89 ca             	mov    rdx,r9
   1855b3e47:	4d 89 f0             	mov    r8,r14
   1855b3e4a:	e8 01 02 f9 01       	call   0x187544050
   1855b3e4f:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b3e54:	48 83 c7 58          	add    rdi,0x58
   1855b3e58:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1855b3e5c:	48 8d 98 d0 07 00 00 	lea    rbx,[rax+0x7d0]
   1855b3e63:	48 39 fb             	cmp    rbx,rdi
   1855b3e66:	0f 84 cb 00 00 00    	je     0x1855b3f37
   1855b3e6c:	4d 8b 77 68          	mov    r14,QWORD PTR [r15+0x68]
   1855b3e70:	49 83 7f 70 10       	cmp    QWORD PTR [r15+0x70],0x10
   1855b3e75:	72 04                	jb     0x1855b3e7b
   1855b3e77:	49 8b 7f 58          	mov    rdi,QWORD PTR [r15+0x58]
   1855b3e7b:	48 8b 88 e8 07 00 00 	mov    rcx,QWORD PTR [rax+0x7e8]
   1855b3e82:	49 39 ce             	cmp    r14,rcx
   1855b3e85:	0f 86 89 00 00 00    	jbe    0x1855b3f14
   1855b3e8b:	48 89 d9             	mov    rcx,rbx
   1855b3e8e:	4c 89 f2             	mov    rdx,r14
   1855b3e91:	49 89 f9             	mov    r9,rdi
   1855b3e94:	e8 b7 a2 a8 fa       	call   0x18003e150
   1855b3e99:	90                   	nop
   1855b3e9a:	e9 98 00 00 00       	jmp    0x1855b3f37
   1855b3e9f:	48 83 f9 10          	cmp    rcx,0x10
   1855b3ea3:	72 03                	jb     0x1855b3ea8
   1855b3ea5:	4d 8b 3f             	mov    r15,QWORD PTR [r15]
   1855b3ea8:	4c 89 a0 88 07 00 00 	mov    QWORD PTR [rax+0x788],r12
   1855b3eaf:	4c 89 f9             	mov    rcx,r15
   1855b3eb2:	4c 89 ca             	mov    rdx,r9
   1855b3eb5:	4d 89 e0             	mov    r8,r12
   1855b3eb8:	e8 93 01 f9 01       	call   0x187544050
   1855b3ebd:	43 c6 04 27 00       	mov    BYTE PTR [r15+r12*1],0x0
   1855b3ec2:	48 89 f9             	mov    rcx,rdi
   1855b3ec5:	e8 56 09 91 fd       	call   0x182ec4820
   1855b3eca:	90                   	nop
   1855b3ecb:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   1855b3ed2:	4c 8d b9 98 07 00 00 	lea    r15,[rcx+0x798]
   1855b3ed9:	49 39 c7             	cmp    r15,rax
   1855b3edc:	0f 84 ff 00 00 00    	je     0x1855b3fe1
   1855b3ee2:	4c 8b 60 10          	mov    r12,QWORD PTR [rax+0x10]
   1855b3ee6:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   1855b3eeb:	72 03                	jb     0x1855b3ef0
   1855b3eed:	48 8b 00             	mov    rax,QWORD PTR [rax]
   1855b3ef0:	48 8b 91 b0 07 00 00 	mov    rdx,QWORD PTR [rcx+0x7b0]
   1855b3ef7:	49 39 d4             	cmp    r12,rdx
   1855b3efa:	0f 86 be 00 00 00    	jbe    0x1855b3fbe
   1855b3f00:	4c 89 f9             	mov    rcx,r15
   1855b3f03:	4c 89 e2             	mov    rdx,r12
   1855b3f06:	49 89 c1             	mov    r9,rax
   1855b3f09:	e8 42 a2 a8 fa       	call   0x18003e150
   1855b3f0e:	90                   	nop
   1855b3f0f:	e9 cd 00 00 00       	jmp    0x1855b3fe1
   1855b3f14:	48 83 f9 10          	cmp    rcx,0x10
   1855b3f18:	72 03                	jb     0x1855b3f1d
   1855b3f1a:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b3f1d:	4c 89 b0 e0 07 00 00 	mov    QWORD PTR [rax+0x7e0],r14
   1855b3f24:	48 89 d9             	mov    rcx,rbx
   1855b3f27:	48 89 fa             	mov    rdx,rdi
   1855b3f2a:	4d 89 f0             	mov    r8,r14
   1855b3f2d:	e8 1e 01 f9 01       	call   0x187544050
   1855b3f32:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b3f37:	f2 41 0f 2c 4f 10    	cvttsd2si ecx,QWORD PTR [r15+0x10]
   1855b3f3d:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1855b3f41:	89 88 68 07 00 00    	mov    DWORD PTR [rax+0x768],ecx
   1855b3f47:	48 8b 4d f8          	mov    rcx,QWORD PTR [rbp-0x8]
   1855b3f4b:	48 85 c9             	test   rcx,rcx
   1855b3f4e:	74 52                	je     0x1855b3fa2
   1855b3f50:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   1855b3f54:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1855b3f58:	48 8b 4d f8          	mov    rcx,QWORD PTR [rbp-0x8]
   1855b3f5c:	eb 46                	jmp    0x1855b3fa4
   1855b3f5e:	48 83 fa 10          	cmp    rdx,0x10
   1855b3f62:	72 03                	jb     0x1855b3f67
   1855b3f64:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b3f67:	4c 89 b1 68 07 00 00 	mov    QWORD PTR [rcx+0x768],r14
   1855b3f6e:	48 89 d9             	mov    rcx,rbx
   1855b3f71:	48 89 c2             	mov    rdx,rax
   1855b3f74:	4d 89 f0             	mov    r8,r14
   1855b3f77:	e8 d4 00 f9 01       	call   0x187544050
   1855b3f7c:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b3f81:	48 89 f9             	mov    rcx,rdi
   1855b3f84:	e8 b7 06 91 fd       	call   0x182ec4640
   1855b3f89:	90                   	nop
   1855b3f8a:	48 8b 48 10          	mov    rcx,QWORD PTR [rax+0x10]
   1855b3f8e:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1855b3f92:	48 89 88 c8 01 00 00 	mov    QWORD PTR [rax+0x1c8],rcx
   1855b3f99:	48 8b 4d f8          	mov    rcx,QWORD PTR [rbp-0x8]
   1855b3f9d:	48 85 c9             	test   rcx,rcx
   1855b3fa0:	75 ae                	jne    0x1855b3f50
   1855b3fa2:	31 c9                	xor    ecx,ecx
   1855b3fa4:	49 89 45 00          	mov    QWORD PTR [r13+0x0],rax
   1855b3fa8:	49 8b 7d 08          	mov    rdi,QWORD PTR [r13+0x8]
   1855b3fac:	49 89 4d 08          	mov    QWORD PTR [r13+0x8],rcx
   1855b3fb0:	48 85 ff             	test   rdi,rdi
   1855b3fb3:	0f 85 90 05 00 00    	jne    0x1855b4549
   1855b3fb9:	e9 a8 05 00 00       	jmp    0x1855b4566
   1855b3fbe:	48 83 fa 10          	cmp    rdx,0x10
   1855b3fc2:	72 03                	jb     0x1855b3fc7
   1855b3fc4:	4d 8b 3f             	mov    r15,QWORD PTR [r15]
   1855b3fc7:	4c 89 a1 a8 07 00 00 	mov    QWORD PTR [rcx+0x7a8],r12
   1855b3fce:	4c 89 f9             	mov    rcx,r15
   1855b3fd1:	48 89 c2             	mov    rdx,rax
   1855b3fd4:	4d 89 e0             	mov    r8,r12
   1855b3fd7:	e8 74 00 f9 01       	call   0x187544050
   1855b3fdc:	43 c6 04 27 00       	mov    BYTE PTR [r15+r12*1],0x0
   1855b3fe1:	4c 8b ab f8 00 00 00 	mov    r13,QWORD PTR [rbx+0xf8]
   1855b3fe8:	48 83 bb 00 01 00 00 	cmp    QWORD PTR [rbx+0x100],0x10
   1855b3fef:	10 
   1855b3ff0:	72 09                	jb     0x1855b3ffb
   1855b3ff2:	4c 8b a3 e8 00 00 00 	mov    r12,QWORD PTR [rbx+0xe8]
   1855b3ff9:	eb 07                	jmp    0x1855b4002
   1855b3ffb:	4d 8d a6 e8 00 00 00 	lea    r12,[r14+0xe8]
   1855b4002:	4d 85 ed             	test   r13,r13
   1855b4005:	0f 88 7c 18 00 00    	js     0x1855b5887
   1855b400b:	49 83 fd 0f          	cmp    r13,0xf
   1855b400f:	4c 89 b5 d8 00 00 00 	mov    QWORD PTR [rbp+0xd8],r14
   1855b4016:	77 2b                	ja     0x1855b4043
   1855b4018:	4d 8b 3c 24          	mov    r15,QWORD PTR [r12]
   1855b401c:	4d 8b 64 24 08       	mov    r12,QWORD PTR [r12+0x8]
   1855b4021:	be 0f 00 00 00       	mov    esi,0xf
   1855b4026:	4c 8b b5 00 01 00 00 	mov    r14,QWORD PTR [rbp+0x100]
   1855b402d:	49 8b 86 20 08 00 00 	mov    rax,QWORD PTR [r14+0x820]
   1855b4034:	48 83 f8 10          	cmp    rax,0x10
   1855b4038:	0f 83 48 06 00 00    	jae    0x1855b4686
   1855b403e:	e9 7b 06 00 00       	jmp    0x1855b46be
   1855b4043:	4c 89 e8             	mov    rax,r13
   1855b4046:	48 83 c8 0f          	or     rax,0xf
   1855b404a:	48 83 f8 17          	cmp    rax,0x17
   1855b404e:	be 16 00 00 00       	mov    esi,0x16
   1855b4053:	48 0f 43 f0          	cmovae rsi,rax
   1855b4057:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1855b405d:	0f 82 f0 05 00 00    	jb     0x1855b4653
   1855b4063:	48 8d 4e 28          	lea    rcx,[rsi+0x28]
   1855b4067:	e8 30 78 ef 01       	call   0x1874ab89c
   1855b406c:	90                   	nop
   1855b406d:	49 89 c7             	mov    r15,rax
   1855b4070:	48 85 c0             	test   rax,rax
   1855b4073:	0f 84 03 18 00 00    	je     0x1855b587c
   1855b4079:	4c 89 f8             	mov    rax,r15
   1855b407c:	49 83 c7 27          	add    r15,0x27
   1855b4080:	49 83 e7 e0          	and    r15,0xffffffffffffffe0
   1855b4084:	49 89 47 f8          	mov    QWORD PTR [r15-0x8],rax
   1855b4088:	e9 d3 05 00 00       	jmp    0x1855b4660
   1855b408d:	b9 04 00 00 00       	mov    ecx,0x4
   1855b4092:	e8 49 8d ab fa       	call   0x18006cde0
   1855b4097:	bb 01 00 00 00       	mov    ebx,0x1
   1855b409c:	85 c0                	test   eax,eax
   1855b409e:	0f 84 c1 17 00 00    	je     0x1855b5865
   1855b40a4:	48 8d b5 80 00 00 00 	lea    rsi,[rbp+0x80]
   1855b40ab:	48 89 f1             	mov    rcx,rsi
   1855b40ae:	e8 5d 8e ab fa       	call   0x18006cf10
   1855b40b3:	48 83 bd 98 00 00 00 	cmp    QWORD PTR [rbp+0x98],0x10
   1855b40ba:	10 
   1855b40bb:	72 07                	jb     0x1855b40c4
   1855b40bd:	48 8b b5 80 00 00 00 	mov    rsi,QWORD PTR [rbp+0x80]
   1855b40c4:	48 8d 05 15 d8 26 04 	lea    rax,[rip+0x426d815]        # 0x1898218e0
   1855b40cb:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b40d0:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b40d7:	00 00 
   1855b40d9:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b40de:	c7 44 24 28 c5 00 00 	mov    DWORD PTR [rsp+0x28],0xc5
   1855b40e5:	00 
   1855b40e6:	4c 8d 0d 53 d8 26 04 	lea    r9,[rip+0x426d853]        # 0x189821940
   1855b40ed:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b40f1:	ba 04 00 00 00       	mov    edx,0x4
   1855b40f6:	49 89 f0             	mov    r8,rsi
   1855b40f9:	e8 72 91 ab fa       	call   0x18006d270
   1855b40fe:	90                   	nop
   1855b40ff:	0f 57 c0             	xorps  xmm0,xmm0
   1855b4102:	0f 29 85 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm0
   1855b4109:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   1855b4110:	0f 29 85 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm0
   1855b4117:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   1855b411e:	0f 29 85 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm0
   1855b4125:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   1855b412c:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   1855b4133:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1855b413a:	48 8d 15 47 d9 26 04 	lea    rdx,[rip+0x426d947]        # 0x189821a88
   1855b4141:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b4145:	4c 8d 85 00 01 00 00 	lea    r8,[rbp+0x100]
   1855b414c:	e8 bf 96 ab fa       	call   0x18006d810
   1855b4151:	90                   	nop
   1855b4152:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b4156:	e8 15 92 ab fa       	call   0x18006d370
   1855b415b:	48 8b 85 98 00 00 00 	mov    rax,QWORD PTR [rbp+0x98]
   1855b4162:	48 83 f8 10          	cmp    rax,0x10
   1855b4166:	0f 82 f9 16 00 00    	jb     0x1855b5865
   1855b416c:	e9 91 15 00 00       	jmp    0x1855b5702
   1855b4171:	48 83 fa 10          	cmp    rdx,0x10
   1855b4175:	72 03                	jb     0x1855b417a
   1855b4177:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b417a:	4c 89 b1 a8 07 00 00 	mov    QWORD PTR [rcx+0x7a8],r14
   1855b4181:	48 89 f9             	mov    rcx,rdi
   1855b4184:	48 89 c2             	mov    rdx,rax
   1855b4187:	4d 89 f0             	mov    r8,r14
   1855b418a:	e8 c1 fe f8 01       	call   0x187544050
   1855b418f:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b4194:	4c 8d 8b 90 01 00 00 	lea    r9,[rbx+0x190]
   1855b419b:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1855b419f:	48 8d b8 58 07 00 00 	lea    rdi,[rax+0x758]
   1855b41a6:	4c 39 cf             	cmp    rdi,r9
   1855b41a9:	0f 84 d3 00 00 00    	je     0x1855b4282
   1855b41af:	4c 8b b3 a0 01 00 00 	mov    r14,QWORD PTR [rbx+0x1a0]
   1855b41b6:	48 83 bb a8 01 00 00 	cmp    QWORD PTR [rbx+0x1a8],0x10
   1855b41bd:	10 
   1855b41be:	72 07                	jb     0x1855b41c7
   1855b41c0:	4c 8b 8b 90 01 00 00 	mov    r9,QWORD PTR [rbx+0x190]
   1855b41c7:	48 8b 88 70 07 00 00 	mov    rcx,QWORD PTR [rax+0x770]
   1855b41ce:	49 39 ce             	cmp    r14,rcx
   1855b41d1:	0f 86 88 00 00 00    	jbe    0x1855b425f
   1855b41d7:	48 89 f9             	mov    rcx,rdi
   1855b41da:	4c 89 f2             	mov    rdx,r14
   1855b41dd:	e8 6e 9f a8 fa       	call   0x18003e150
   1855b41e2:	90                   	nop
   1855b41e3:	e9 9a 00 00 00       	jmp    0x1855b4282
   1855b41e8:	48 83 fa 10          	cmp    rdx,0x10
   1855b41ec:	72 03                	jb     0x1855b41f1
   1855b41ee:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b41f1:	4c 89 b1 a8 07 00 00 	mov    QWORD PTR [rcx+0x7a8],r14
   1855b41f8:	48 89 f9             	mov    rcx,rdi
   1855b41fb:	48 89 c2             	mov    rdx,rax
   1855b41fe:	4d 89 f0             	mov    r8,r14
   1855b4201:	e8 4a fe f8 01       	call   0x187544050
   1855b4206:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b420b:	4c 8d 8b 90 01 00 00 	lea    r9,[rbx+0x190]
   1855b4212:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1855b4216:	48 8d b8 58 07 00 00 	lea    rdi,[rax+0x758]
   1855b421d:	4c 39 cf             	cmp    rdi,r9
   1855b4220:	0f 84 d3 00 00 00    	je     0x1855b42f9
   1855b4226:	4c 8b b3 a0 01 00 00 	mov    r14,QWORD PTR [rbx+0x1a0]
   1855b422d:	48 83 bb a8 01 00 00 	cmp    QWORD PTR [rbx+0x1a8],0x10
   1855b4234:	10 
   1855b4235:	72 07                	jb     0x1855b423e
   1855b4237:	4c 8b 8b 90 01 00 00 	mov    r9,QWORD PTR [rbx+0x190]
   1855b423e:	48 8b 88 70 07 00 00 	mov    rcx,QWORD PTR [rax+0x770]
   1855b4245:	49 39 ce             	cmp    r14,rcx
   1855b4248:	0f 86 88 00 00 00    	jbe    0x1855b42d6
   1855b424e:	48 89 f9             	mov    rcx,rdi
   1855b4251:	4c 89 f2             	mov    rdx,r14
   1855b4254:	e8 f7 9e a8 fa       	call   0x18003e150
   1855b4259:	90                   	nop
   1855b425a:	e9 9a 00 00 00       	jmp    0x1855b42f9
   1855b425f:	48 83 f9 10          	cmp    rcx,0x10
   1855b4263:	72 03                	jb     0x1855b4268
   1855b4265:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b4268:	4c 89 b0 68 07 00 00 	mov    QWORD PTR [rax+0x768],r14
   1855b426f:	48 89 f9             	mov    rcx,rdi
   1855b4272:	4c 89 ca             	mov    rdx,r9
   1855b4275:	4d 89 f0             	mov    r8,r14
   1855b4278:	e8 d3 fd f8 01       	call   0x187544050
   1855b427d:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b4282:	4c 8d 8b b0 01 00 00 	lea    r9,[rbx+0x1b0]
   1855b4289:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1855b428d:	48 8d b8 78 07 00 00 	lea    rdi,[rax+0x778]
   1855b4294:	4c 39 cf             	cmp    rdi,r9
   1855b4297:	0f 84 d3 00 00 00    	je     0x1855b4370
   1855b429d:	4c 8b b3 c0 01 00 00 	mov    r14,QWORD PTR [rbx+0x1c0]
   1855b42a4:	48 83 bb c8 01 00 00 	cmp    QWORD PTR [rbx+0x1c8],0x10
   1855b42ab:	10 
   1855b42ac:	72 07                	jb     0x1855b42b5
   1855b42ae:	4c 8b 8b b0 01 00 00 	mov    r9,QWORD PTR [rbx+0x1b0]
   1855b42b5:	48 8b 88 90 07 00 00 	mov    rcx,QWORD PTR [rax+0x790]
   1855b42bc:	49 39 ce             	cmp    r14,rcx
   1855b42bf:	0f 86 88 00 00 00    	jbe    0x1855b434d
   1855b42c5:	48 89 f9             	mov    rcx,rdi
   1855b42c8:	4c 89 f2             	mov    rdx,r14
   1855b42cb:	e8 80 9e a8 fa       	call   0x18003e150
   1855b42d0:	90                   	nop
   1855b42d1:	e9 9a 00 00 00       	jmp    0x1855b4370
   1855b42d6:	48 83 f9 10          	cmp    rcx,0x10
   1855b42da:	72 03                	jb     0x1855b42df
   1855b42dc:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b42df:	4c 89 b0 68 07 00 00 	mov    QWORD PTR [rax+0x768],r14
   1855b42e6:	48 89 f9             	mov    rcx,rdi
   1855b42e9:	4c 89 ca             	mov    rdx,r9
   1855b42ec:	4d 89 f0             	mov    r8,r14
   1855b42ef:	e8 5c fd f8 01       	call   0x187544050
   1855b42f4:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b42f9:	4c 8d 8b b0 01 00 00 	lea    r9,[rbx+0x1b0]
   1855b4300:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1855b4304:	48 8d b8 78 07 00 00 	lea    rdi,[rax+0x778]
   1855b430b:	4c 39 cf             	cmp    rdi,r9
   1855b430e:	0f 84 d3 00 00 00    	je     0x1855b43e7
   1855b4314:	4c 8b b3 c0 01 00 00 	mov    r14,QWORD PTR [rbx+0x1c0]
   1855b431b:	48 83 bb c8 01 00 00 	cmp    QWORD PTR [rbx+0x1c8],0x10
   1855b4322:	10 
   1855b4323:	72 07                	jb     0x1855b432c
   1855b4325:	4c 8b 8b b0 01 00 00 	mov    r9,QWORD PTR [rbx+0x1b0]
   1855b432c:	48 8b 88 90 07 00 00 	mov    rcx,QWORD PTR [rax+0x790]
   1855b4333:	49 39 ce             	cmp    r14,rcx
   1855b4336:	0f 86 88 00 00 00    	jbe    0x1855b43c4
   1855b433c:	48 89 f9             	mov    rcx,rdi
   1855b433f:	4c 89 f2             	mov    rdx,r14
   1855b4342:	e8 09 9e a8 fa       	call   0x18003e150
   1855b4347:	90                   	nop
   1855b4348:	e9 9a 00 00 00       	jmp    0x1855b43e7
   1855b434d:	48 83 f9 10          	cmp    rcx,0x10
   1855b4351:	72 03                	jb     0x1855b4356
   1855b4353:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b4356:	4c 89 b0 88 07 00 00 	mov    QWORD PTR [rax+0x788],r14
   1855b435d:	48 89 f9             	mov    rcx,rdi
   1855b4360:	4c 89 ca             	mov    rdx,r9
   1855b4363:	4d 89 f0             	mov    r8,r14
   1855b4366:	e8 e5 fc f8 01       	call   0x187544050
   1855b436b:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b4370:	4c 8d 8b c0 04 00 00 	lea    r9,[rbx+0x4c0]
   1855b4377:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1855b437b:	48 8d b8 e0 07 00 00 	lea    rdi,[rax+0x7e0]
   1855b4382:	4c 39 cf             	cmp    rdi,r9
   1855b4385:	0f 84 cf 00 00 00    	je     0x1855b445a
   1855b438b:	4c 8b b3 d0 04 00 00 	mov    r14,QWORD PTR [rbx+0x4d0]
   1855b4392:	48 83 bb d8 04 00 00 	cmp    QWORD PTR [rbx+0x4d8],0x10
   1855b4399:	10 
   1855b439a:	72 07                	jb     0x1855b43a3
   1855b439c:	4c 8b 8b c0 04 00 00 	mov    r9,QWORD PTR [rbx+0x4c0]
   1855b43a3:	48 8b 88 f8 07 00 00 	mov    rcx,QWORD PTR [rax+0x7f8]
   1855b43aa:	49 39 ce             	cmp    r14,rcx
   1855b43ad:	0f 86 84 00 00 00    	jbe    0x1855b4437
   1855b43b3:	48 89 f9             	mov    rcx,rdi
   1855b43b6:	4c 89 f2             	mov    rdx,r14
   1855b43b9:	e8 92 9d a8 fa       	call   0x18003e150
   1855b43be:	90                   	nop
   1855b43bf:	e9 96 00 00 00       	jmp    0x1855b445a
   1855b43c4:	48 83 f9 10          	cmp    rcx,0x10
   1855b43c8:	72 03                	jb     0x1855b43cd
   1855b43ca:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b43cd:	4c 89 b0 88 07 00 00 	mov    QWORD PTR [rax+0x788],r14
   1855b43d4:	48 89 f9             	mov    rcx,rdi
   1855b43d7:	4c 89 ca             	mov    rdx,r9
   1855b43da:	4d 89 f0             	mov    r8,r14
   1855b43dd:	e8 6e fc f8 01       	call   0x187544050
   1855b43e2:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b43e7:	4c 8d 8b c0 04 00 00 	lea    r9,[rbx+0x4c0]
   1855b43ee:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1855b43f2:	48 8d b8 e0 07 00 00 	lea    rdi,[rax+0x7e0]
   1855b43f9:	4c 39 cf             	cmp    rdi,r9
   1855b43fc:	0f 84 c0 00 00 00    	je     0x1855b44c2
   1855b4402:	4c 8b b3 d0 04 00 00 	mov    r14,QWORD PTR [rbx+0x4d0]
   1855b4409:	48 83 bb d8 04 00 00 	cmp    QWORD PTR [rbx+0x4d8],0x10
   1855b4410:	10 
   1855b4411:	72 07                	jb     0x1855b441a
   1855b4413:	4c 8b 8b c0 04 00 00 	mov    r9,QWORD PTR [rbx+0x4c0]
   1855b441a:	48 8b 88 f8 07 00 00 	mov    rcx,QWORD PTR [rax+0x7f8]
   1855b4421:	49 39 ce             	cmp    r14,rcx
   1855b4424:	76 79                	jbe    0x1855b449f
   1855b4426:	48 89 f9             	mov    rcx,rdi
   1855b4429:	4c 89 f2             	mov    rdx,r14
   1855b442c:	e8 1f 9d a8 fa       	call   0x18003e150
   1855b4431:	90                   	nop
   1855b4432:	e9 8b 00 00 00       	jmp    0x1855b44c2
   1855b4437:	48 83 f9 10          	cmp    rcx,0x10
   1855b443b:	72 03                	jb     0x1855b4440
   1855b443d:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b4440:	4c 89 b0 f0 07 00 00 	mov    QWORD PTR [rax+0x7f0],r14
   1855b4447:	48 89 f9             	mov    rcx,rdi
   1855b444a:	4c 89 ca             	mov    rdx,r9
   1855b444d:	4d 89 f0             	mov    r8,r14
   1855b4450:	e8 fb fb f8 01       	call   0x187544050
   1855b4455:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b445a:	48 8b 83 d8 05 00 00 	mov    rax,QWORD PTR [rbx+0x5d8]
   1855b4461:	48 85 c0             	test   rax,rax
   1855b4464:	74 0d                	je     0x1855b4473
   1855b4466:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1855b446a:	48 8b 83 d8 05 00 00 	mov    rax,QWORD PTR [rbx+0x5d8]
   1855b4471:	eb 02                	jmp    0x1855b4475
   1855b4473:	31 c0                	xor    eax,eax
   1855b4475:	48 8b 8b d0 05 00 00 	mov    rcx,QWORD PTR [rbx+0x5d0]
   1855b447c:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
   1855b4480:	48 89 8a 00 08 00 00 	mov    QWORD PTR [rdx+0x800],rcx
   1855b4487:	48 8b ba 08 08 00 00 	mov    rdi,QWORD PTR [rdx+0x808]
   1855b448e:	48 89 82 08 08 00 00 	mov    QWORD PTR [rdx+0x808],rax
   1855b4495:	48 85 ff             	test   rdi,rdi
   1855b4498:	75 68                	jne    0x1855b4502
   1855b449a:	e9 80 00 00 00       	jmp    0x1855b451f
   1855b449f:	48 83 f9 10          	cmp    rcx,0x10
   1855b44a3:	72 03                	jb     0x1855b44a8
   1855b44a5:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b44a8:	4c 89 b0 f0 07 00 00 	mov    QWORD PTR [rax+0x7f0],r14
   1855b44af:	48 89 f9             	mov    rcx,rdi
   1855b44b2:	4c 89 ca             	mov    rdx,r9
   1855b44b5:	4d 89 f0             	mov    r8,r14
   1855b44b8:	e8 93 fb f8 01       	call   0x187544050
   1855b44bd:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b44c2:	48 8b 83 e8 05 00 00 	mov    rax,QWORD PTR [rbx+0x5e8]
   1855b44c9:	48 85 c0             	test   rax,rax
   1855b44cc:	74 0d                	je     0x1855b44db
   1855b44ce:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1855b44d2:	48 8b 83 e8 05 00 00 	mov    rax,QWORD PTR [rbx+0x5e8]
   1855b44d9:	eb 02                	jmp    0x1855b44dd
   1855b44db:	31 c0                	xor    eax,eax
   1855b44dd:	48 8b 8b e0 05 00 00 	mov    rcx,QWORD PTR [rbx+0x5e0]
   1855b44e4:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
   1855b44e8:	48 89 8a 10 08 00 00 	mov    QWORD PTR [rdx+0x810],rcx
   1855b44ef:	48 8b ba 18 08 00 00 	mov    rdi,QWORD PTR [rdx+0x818]
   1855b44f6:	48 89 82 18 08 00 00 	mov    QWORD PTR [rdx+0x818],rax
   1855b44fd:	48 85 ff             	test   rdi,rdi
   1855b4500:	74 1d                	je     0x1855b451f
   1855b4502:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1855b4506:	75 17                	jne    0x1855b451f
   1855b4508:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b450b:	48 89 f9             	mov    rcx,rdi
   1855b450e:	ff 10                	call   QWORD PTR [rax]
   1855b4510:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1855b4514:	75 09                	jne    0x1855b451f
   1855b4516:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b4519:	48 89 f9             	mov    rcx,rdi
   1855b451c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b451f:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   1855b4523:	48 85 c0             	test   rax,rax
   1855b4526:	74 0a                	je     0x1855b4532
   1855b4528:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1855b452c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   1855b4530:	eb 02                	jmp    0x1855b4534
   1855b4532:	31 c0                	xor    eax,eax
   1855b4534:	48 8b 4d f0          	mov    rcx,QWORD PTR [rbp-0x10]
   1855b4538:	49 89 4d 00          	mov    QWORD PTR [r13+0x0],rcx
   1855b453c:	49 8b 7d 08          	mov    rdi,QWORD PTR [r13+0x8]
   1855b4540:	49 89 45 08          	mov    QWORD PTR [r13+0x8],rax
   1855b4544:	48 85 ff             	test   rdi,rdi
   1855b4547:	74 1d                	je     0x1855b4566
   1855b4549:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1855b454d:	75 17                	jne    0x1855b4566
   1855b454f:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b4552:	48 89 f9             	mov    rcx,rdi
   1855b4555:	ff 10                	call   QWORD PTR [rax]
   1855b4557:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1855b455b:	75 09                	jne    0x1855b4566
   1855b455d:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b4560:	48 89 f9             	mov    rcx,rdi
   1855b4563:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b4566:	48 8b 75 f8          	mov    rsi,QWORD PTR [rbp-0x8]
   1855b456a:	48 85 f6             	test   rsi,rsi
   1855b456d:	0f 85 d3 12 00 00    	jne    0x1855b5846
   1855b4573:	e9 eb 12 00 00       	jmp    0x1855b5863
   1855b4578:	0f 28 05 31 16 79 03 	movaps xmm0,XMMWORD PTR [rip+0x3791631]        # 0x188d45bb0
   1855b457f:	0f 29 45 f0          	movaps XMMWORD PTR [rbp-0x10],xmm0
   1855b4583:	48 89 f9             	mov    rcx,rdi
   1855b4586:	e8 15 08 91 fd       	call   0x182ec4da0
   1855b458b:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b458f:	48 89 c2             	mov    rdx,rax
   1855b4592:	41 b8 18 00 00 00    	mov    r8d,0x18
   1855b4598:	e8 f3 aa 00 00       	call   0x1855bf090
   1855b459d:	48 83 7d f0 00       	cmp    QWORD PTR [rbp-0x10],0x0
   1855b45a2:	0f 84 97 11 00 00    	je     0x1855b573f
   1855b45a8:	48 8d 7d f0          	lea    rdi,[rbp-0x10]
   1855b45ac:	4c 89 e9             	mov    rcx,r13
   1855b45af:	48 89 fa             	mov    rdx,rdi
   1855b45b2:	e8 89 b2 16 fb       	call   0x18071f840
   1855b45b7:	48 89 f9             	mov    rcx,rdi
   1855b45ba:	e8 a1 da a4 fa       	call   0x180002060
   1855b45bf:	e9 9f 12 00 00       	jmp    0x1855b5863
   1855b45c4:	48 8d 4e 01          	lea    rcx,[rsi+0x1]
   1855b45c8:	e8 cf 72 ef 01       	call   0x1874ab89c
   1855b45cd:	48 89 85 80 00 00 00 	mov    QWORD PTR [rbp+0x80],rax
   1855b45d4:	4c 89 bd 90 00 00 00 	mov    QWORD PTR [rbp+0x90],r15
   1855b45db:	48 89 b5 98 00 00 00 	mov    QWORD PTR [rbp+0x98],rsi
   1855b45e2:	49 ff c7             	inc    r15
   1855b45e5:	48 89 c1             	mov    rcx,rax
   1855b45e8:	4c 89 e2             	mov    rdx,r12
   1855b45eb:	4d 89 f8             	mov    r8,r15
   1855b45ee:	e8 5d fa f8 01       	call   0x187544050
   1855b45f3:	4c 8b bd 90 00 00 00 	mov    r15,QWORD PTR [rbp+0x90]
   1855b45fa:	4d 85 ff             	test   r15,r15
   1855b45fd:	0f 85 24 0a 00 00    	jne    0x1855b5027
   1855b4603:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1855b4606:	48 89 d9             	mov    rcx,rbx
   1855b4609:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1855b460c:	90                   	nop
   1855b460d:	4c 8d a5 80 00 00 00 	lea    r12,[rbp+0x80]
   1855b4614:	49 39 c4             	cmp    r12,rax
   1855b4617:	0f 84 0a 0a 00 00    	je     0x1855b5027
   1855b461d:	4c 8b 78 10          	mov    r15,QWORD PTR [rax+0x10]
   1855b4621:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   1855b4626:	72 03                	jb     0x1855b462b
   1855b4628:	48 8b 00             	mov    rax,QWORD PTR [rax]
   1855b462b:	48 8b 8d 98 00 00 00 	mov    rcx,QWORD PTR [rbp+0x98]
   1855b4632:	49 39 cf             	cmp    r15,rcx
   1855b4635:	0f 86 c5 09 00 00    	jbe    0x1855b5000
   1855b463b:	48 8d 8d 80 00 00 00 	lea    rcx,[rbp+0x80]
   1855b4642:	4c 89 fa             	mov    rdx,r15
   1855b4645:	49 89 c1             	mov    r9,rax
   1855b4648:	e8 03 9b a8 fa       	call   0x18003e150
   1855b464d:	90                   	nop
   1855b464e:	e9 d4 09 00 00       	jmp    0x1855b5027
   1855b4653:	48 8d 4e 01          	lea    rcx,[rsi+0x1]
   1855b4657:	e8 40 72 ef 01       	call   0x1874ab89c
   1855b465c:	90                   	nop
   1855b465d:	49 89 c7             	mov    r15,rax
   1855b4660:	4d 8d 45 01          	lea    r8,[r13+0x1]
   1855b4664:	4c 89 f9             	mov    rcx,r15
   1855b4667:	4c 89 e2             	mov    rdx,r12
   1855b466a:	e8 e1 f9 f8 01       	call   0x187544050
   1855b466f:	45 31 e4             	xor    r12d,r12d
   1855b4672:	4c 8b b5 00 01 00 00 	mov    r14,QWORD PTR [rbp+0x100]
   1855b4679:	49 8b 86 20 08 00 00 	mov    rax,QWORD PTR [r14+0x820]
   1855b4680:	48 83 f8 10          	cmp    rax,0x10
   1855b4684:	72 38                	jb     0x1855b46be
   1855b4686:	49 8b 8e 08 08 00 00 	mov    rcx,QWORD PTR [r14+0x808]
   1855b468d:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1855b4691:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1855b4698:	72 1f                	jb     0x1855b46b9
   1855b469a:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1855b469e:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1855b46a2:	4c 29 c1             	sub    rcx,r8
   1855b46a5:	48 83 f9 20          	cmp    rcx,0x20
   1855b46a9:	0f 83 cd 11 00 00    	jae    0x1855b587c
   1855b46af:	48 83 c0 28          	add    rax,0x28
   1855b46b3:	48 89 c2             	mov    rdx,rax
   1855b46b6:	4c 89 c1             	mov    rcx,r8
   1855b46b9:	e8 22 72 ef 01       	call   0x1874ab8e0
   1855b46be:	4d 89 be 08 08 00 00 	mov    QWORD PTR [r14+0x808],r15
   1855b46c5:	4d 89 a6 10 08 00 00 	mov    QWORD PTR [r14+0x810],r12
   1855b46cc:	4d 89 ae 18 08 00 00 	mov    QWORD PTR [r14+0x818],r13
   1855b46d3:	49 89 b6 20 08 00 00 	mov    QWORD PTR [r14+0x820],rsi
   1855b46da:	48 8b b5 d8 00 00 00 	mov    rsi,QWORD PTR [rbp+0xd8]
   1855b46e1:	4c 8d 8e b0 01 00 00 	lea    r9,[rsi+0x1b0]
   1855b46e8:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b46ef:	4c 8d b8 e8 07 00 00 	lea    r15,[rax+0x7e8]
   1855b46f6:	4d 39 cf             	cmp    r15,r9
   1855b46f9:	74 55                	je     0x1855b4750
   1855b46fb:	4c 8b a3 c0 01 00 00 	mov    r12,QWORD PTR [rbx+0x1c0]
   1855b4702:	48 83 bb c8 01 00 00 	cmp    QWORD PTR [rbx+0x1c8],0x10
   1855b4709:	10 
   1855b470a:	72 07                	jb     0x1855b4713
   1855b470c:	4c 8b 8b b0 01 00 00 	mov    r9,QWORD PTR [rbx+0x1b0]
   1855b4713:	48 8b 88 00 08 00 00 	mov    rcx,QWORD PTR [rax+0x800]
   1855b471a:	49 39 cc             	cmp    r12,rcx
   1855b471d:	76 0e                	jbe    0x1855b472d
   1855b471f:	4c 89 f9             	mov    rcx,r15
   1855b4722:	4c 89 e2             	mov    rdx,r12
   1855b4725:	e8 26 9a a8 fa       	call   0x18003e150
   1855b472a:	90                   	nop
   1855b472b:	eb 23                	jmp    0x1855b4750
   1855b472d:	48 83 f9 10          	cmp    rcx,0x10
   1855b4731:	72 03                	jb     0x1855b4736
   1855b4733:	4d 8b 3f             	mov    r15,QWORD PTR [r15]
   1855b4736:	4c 89 a0 f8 07 00 00 	mov    QWORD PTR [rax+0x7f8],r12
   1855b473d:	4c 89 f9             	mov    rcx,r15
   1855b4740:	4c 89 ca             	mov    rdx,r9
   1855b4743:	4d 89 e0             	mov    r8,r12
   1855b4746:	e8 05 f9 f8 01       	call   0x187544050
   1855b474b:	43 c6 04 27 00       	mov    BYTE PTR [r15+r12*1],0x0
   1855b4750:	48 81 c6 90 01 00 00 	add    rsi,0x190
   1855b4757:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b475e:	4c 8d b8 b8 07 00 00 	lea    r15,[rax+0x7b8]
   1855b4765:	49 39 f7             	cmp    r15,rsi
   1855b4768:	74 58                	je     0x1855b47c2
   1855b476a:	4c 8b a3 a0 01 00 00 	mov    r12,QWORD PTR [rbx+0x1a0]
   1855b4771:	48 83 bb a8 01 00 00 	cmp    QWORD PTR [rbx+0x1a8],0x10
   1855b4778:	10 
   1855b4779:	49 89 f1             	mov    r9,rsi
   1855b477c:	72 07                	jb     0x1855b4785
   1855b477e:	4c 8b 8b 90 01 00 00 	mov    r9,QWORD PTR [rbx+0x190]
   1855b4785:	48 8b 88 d0 07 00 00 	mov    rcx,QWORD PTR [rax+0x7d0]
   1855b478c:	49 39 cc             	cmp    r12,rcx
   1855b478f:	76 0e                	jbe    0x1855b479f
   1855b4791:	4c 89 f9             	mov    rcx,r15
   1855b4794:	4c 89 e2             	mov    rdx,r12
   1855b4797:	e8 b4 99 a8 fa       	call   0x18003e150
   1855b479c:	90                   	nop
   1855b479d:	eb 23                	jmp    0x1855b47c2
   1855b479f:	48 83 f9 10          	cmp    rcx,0x10
   1855b47a3:	72 03                	jb     0x1855b47a8
   1855b47a5:	4d 8b 3f             	mov    r15,QWORD PTR [r15]
   1855b47a8:	4c 89 a0 c8 07 00 00 	mov    QWORD PTR [rax+0x7c8],r12
   1855b47af:	4c 89 f9             	mov    rcx,r15
   1855b47b2:	4c 89 ca             	mov    rdx,r9
   1855b47b5:	4d 89 e0             	mov    r8,r12
   1855b47b8:	e8 93 f8 f8 01       	call   0x187544050
   1855b47bd:	43 c6 04 27 00       	mov    BYTE PTR [r15+r12*1],0x0
   1855b47c2:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b47c9:	4c 8d b8 48 08 00 00 	lea    r15,[rax+0x848]
   1855b47d0:	49 39 f7             	cmp    r15,rsi
   1855b47d3:	74 58                	je     0x1855b482d
   1855b47d5:	4c 8b a3 a0 01 00 00 	mov    r12,QWORD PTR [rbx+0x1a0]
   1855b47dc:	48 83 bb a8 01 00 00 	cmp    QWORD PTR [rbx+0x1a8],0x10
   1855b47e3:	10 
   1855b47e4:	72 07                	jb     0x1855b47ed
   1855b47e6:	48 8b b3 90 01 00 00 	mov    rsi,QWORD PTR [rbx+0x190]
   1855b47ed:	48 8b 88 60 08 00 00 	mov    rcx,QWORD PTR [rax+0x860]
   1855b47f4:	49 39 cc             	cmp    r12,rcx
   1855b47f7:	76 11                	jbe    0x1855b480a
   1855b47f9:	4c 89 f9             	mov    rcx,r15
   1855b47fc:	4c 89 e2             	mov    rdx,r12
   1855b47ff:	49 89 f1             	mov    r9,rsi
   1855b4802:	e8 49 99 a8 fa       	call   0x18003e150
   1855b4807:	90                   	nop
   1855b4808:	eb 23                	jmp    0x1855b482d
   1855b480a:	48 83 f9 10          	cmp    rcx,0x10
   1855b480e:	72 03                	jb     0x1855b4813
   1855b4810:	4d 8b 3f             	mov    r15,QWORD PTR [r15]
   1855b4813:	4c 89 a0 58 08 00 00 	mov    QWORD PTR [rax+0x858],r12
   1855b481a:	4c 89 f9             	mov    rcx,r15
   1855b481d:	48 89 f2             	mov    rdx,rsi
   1855b4820:	4d 89 e0             	mov    r8,r12
   1855b4823:	e8 28 f8 f8 01       	call   0x187544050
   1855b4828:	43 c6 04 27 00       	mov    BYTE PTR [r15+r12*1],0x0
   1855b482d:	b9 78 01 00 00       	mov    ecx,0x178
   1855b4832:	e8 65 70 ef 01       	call   0x1874ab89c
   1855b4837:	90                   	nop
   1855b4838:	49 89 c6             	mov    r14,rax
   1855b483b:	48 b8 01 00 00 00 01 	movabs rax,0x100000001
   1855b4842:	00 00 00 
   1855b4845:	49 89 46 08          	mov    QWORD PTR [r14+0x8],rax
   1855b4849:	48 8d 05 88 0d 92 03 	lea    rax,[rip+0x3920d88]        # 0x188ed55d8
   1855b4850:	49 89 06             	mov    QWORD PTR [r14],rax
   1855b4853:	4c 89 b5 d8 00 00 00 	mov    QWORD PTR [rbp+0xd8],r14
   1855b485a:	49 83 c6 10          	add    r14,0x10
   1855b485e:	4c 89 f1             	mov    rcx,r14
   1855b4861:	48 89 da             	mov    rdx,rbx
   1855b4864:	e8 07 8e c0 fa       	call   0x1801bd670
   1855b4869:	90                   	nop
   1855b486a:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b4871:	4c 89 b0 d8 08 00 00 	mov    QWORD PTR [rax+0x8d8],r14
   1855b4878:	48 8b 98 e0 08 00 00 	mov    rbx,QWORD PTR [rax+0x8e0]
   1855b487f:	48 8b 8d d8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xd8]
   1855b4886:	48 89 88 e0 08 00 00 	mov    QWORD PTR [rax+0x8e0],rcx
   1855b488d:	48 85 db             	test   rbx,rbx
   1855b4890:	74 1e                	je     0x1855b48b0
   1855b4892:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1855b4896:	75 18                	jne    0x1855b48b0
   1855b4898:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1855b489b:	48 89 d9             	mov    rcx,rbx
   1855b489e:	ff 10                	call   QWORD PTR [rax]
   1855b48a0:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1855b48a4:	75 0a                	jne    0x1855b48b0
   1855b48a6:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1855b48a9:	48 89 d9             	mov    rcx,rbx
   1855b48ac:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b48af:	90                   	nop
   1855b48b0:	48 89 f9             	mov    rcx,rdi
   1855b48b3:	e8 28 0c 91 fd       	call   0x182ec54e0
   1855b48b8:	90                   	nop
   1855b48b9:	48 89 c7             	mov    rdi,rax
   1855b48bc:	48 85 c0             	test   rax,rax
   1855b48bf:	74 43                	je     0x1855b4904
   1855b48c1:	8b 4f 08             	mov    ecx,DWORD PTR [rdi+0x8]
   1855b48c4:	e8 87 39 e8 fc       	call   0x182438250
   1855b48c9:	90                   	nop
   1855b48ca:	84 c0                	test   al,al
   1855b48cc:	74 36                	je     0x1855b4904
   1855b48ce:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b48d2:	41 b8 01 00 00 00    	mov    r8d,0x1
   1855b48d8:	48 89 fa             	mov    rdx,rdi
   1855b48db:	45 31 c9             	xor    r9d,r9d
   1855b48de:	e8 4d f0 fa fe       	call   0x184563930
   1855b48e3:	90                   	nop
   1855b48e4:	b9 68 08 00 00       	mov    ecx,0x868
   1855b48e9:	48 03 8d 00 01 00 00 	add    rcx,QWORD PTR [rbp+0x100]
   1855b48f0:	48 8d 7d f0          	lea    rdi,[rbp-0x10]
   1855b48f4:	48 89 fa             	mov    rdx,rdi
   1855b48f7:	e8 44 6d ae fa       	call   0x18009b640
   1855b48fc:	48 89 f9             	mov    rcx,rdi
   1855b48ff:	e8 5c 31 a5 fa       	call   0x180007a60
   1855b4904:	48 8b 85 08 01 00 00 	mov    rax,QWORD PTR [rbp+0x108]
   1855b490b:	48 85 c0             	test   rax,rax
   1855b490e:	74 0d                	je     0x1855b491d
   1855b4910:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1855b4914:	48 8b 85 08 01 00 00 	mov    rax,QWORD PTR [rbp+0x108]
   1855b491b:	eb 02                	jmp    0x1855b491f
   1855b491d:	31 c0                	xor    eax,eax
   1855b491f:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
   1855b4923:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   1855b492a:	48 89 0a             	mov    QWORD PTR [rdx],rcx
   1855b492d:	48 8b 7a 08          	mov    rdi,QWORD PTR [rdx+0x8]
   1855b4931:	48 89 42 08          	mov    QWORD PTR [rdx+0x8],rax
   1855b4935:	48 85 ff             	test   rdi,rdi
   1855b4938:	0f 85 ef 04 00 00    	jne    0x1855b4e2d
   1855b493e:	e9 f7 0e 00 00       	jmp    0x1855b583a
   1855b4943:	4c 8d 65 f0          	lea    r12,[rbp-0x10]
   1855b4947:	41 bd 0f 00 00 00    	mov    r13d,0xf
   1855b494d:	e9 1c 0e 00 00       	jmp    0x1855b576e
   1855b4952:	31 c9                	xor    ecx,ecx
   1855b4954:	49 89 45 00          	mov    QWORD PTR [r13+0x0],rax
   1855b4958:	49 8b 5d 08          	mov    rbx,QWORD PTR [r13+0x8]
   1855b495c:	49 89 4d 08          	mov    QWORD PTR [r13+0x8],rcx
   1855b4960:	48 85 db             	test   rbx,rbx
   1855b4963:	74 1e                	je     0x1855b4983
   1855b4965:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1855b4969:	75 18                	jne    0x1855b4983
   1855b496b:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1855b496e:	48 89 d9             	mov    rcx,rbx
   1855b4971:	ff 10                	call   QWORD PTR [rax]
   1855b4973:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1855b4977:	75 0a                	jne    0x1855b4983
   1855b4979:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1855b497c:	48 89 d9             	mov    rcx,rbx
   1855b497f:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b4982:	90                   	nop
   1855b4983:	48 89 f9             	mov    rcx,rdi
   1855b4986:	e8 35 fe 90 fd       	call   0x182ec47c0
   1855b498b:	90                   	nop
   1855b498c:	48 89 c1             	mov    rcx,rax
   1855b498f:	e8 7c 34 cd fc       	call   0x182287e10
   1855b4994:	90                   	nop
   1855b4995:	84 c0                	test   al,al
   1855b4997:	75 1a                	jne    0x1855b49b3
   1855b4999:	48 89 f9             	mov    rcx,rdi
   1855b499c:	e8 3f fe 90 fd       	call   0x182ec47e0
   1855b49a1:	90                   	nop
   1855b49a2:	48 89 c1             	mov    rcx,rax
   1855b49a5:	e8 66 34 cd fc       	call   0x182287e10
   1855b49aa:	90                   	nop
   1855b49ab:	84 c0                	test   al,al
   1855b49ad:	0f 84 c6 00 00 00    	je     0x1855b4a79
   1855b49b3:	e8 68 a5 b1 fa       	call   0x1800cef20
   1855b49b8:	90                   	nop
   1855b49b9:	48 89 c6             	mov    rsi,rax
   1855b49bc:	e8 5f 92 b2 fa       	call   0x1800ddc20
   1855b49c1:	90                   	nop
   1855b49c2:	48 8d 7d f0          	lea    rdi,[rbp-0x10]
   1855b49c6:	48 89 f9             	mov    rcx,rdi
   1855b49c9:	48 89 c2             	mov    rdx,rax
   1855b49cc:	49 89 f0             	mov    r8,rsi
   1855b49cf:	e8 6c 7a fc fa       	call   0x18057c440
   1855b49d4:	90                   	nop
   1855b49d5:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b49dc:	48 8d b0 58 07 00 00 	lea    rsi,[rax+0x758]
   1855b49e3:	48 39 fe             	cmp    rsi,rdi
   1855b49e6:	74 52                	je     0x1855b4a3a
   1855b49e8:	48 8b 80 70 07 00 00 	mov    rax,QWORD PTR [rax+0x770]
   1855b49ef:	48 83 f8 10          	cmp    rax,0x10
   1855b49f3:	72 34                	jb     0x1855b4a29
   1855b49f5:	48 8b 0e             	mov    rcx,QWORD PTR [rsi]
   1855b49f8:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1855b49fc:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1855b4a03:	72 1f                	jb     0x1855b4a24
   1855b4a05:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1855b4a09:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1855b4a0d:	4c 29 c1             	sub    rcx,r8
   1855b4a10:	48 83 f9 20          	cmp    rcx,0x20
   1855b4a14:	0f 83 62 0e 00 00    	jae    0x1855b587c
   1855b4a1a:	48 83 c0 28          	add    rax,0x28
   1855b4a1e:	48 89 c2             	mov    rdx,rax
   1855b4a21:	4c 89 c1             	mov    rcx,r8
   1855b4a24:	e8 b7 6e ef 01       	call   0x1874ab8e0
   1855b4a29:	0f 10 45 f0          	movups xmm0,XMMWORD PTR [rbp-0x10]
   1855b4a2d:	0f 10 4d 00          	movups xmm1,XMMWORD PTR [rbp+0x0]
   1855b4a31:	0f 11 4e 10          	movups XMMWORD PTR [rsi+0x10],xmm1
   1855b4a35:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   1855b4a38:	eb 3f                	jmp    0x1855b4a79
   1855b4a3a:	48 8b 45 08          	mov    rax,QWORD PTR [rbp+0x8]
   1855b4a3e:	48 83 f8 10          	cmp    rax,0x10
   1855b4a42:	72 35                	jb     0x1855b4a79
   1855b4a44:	48 8b 4d f0          	mov    rcx,QWORD PTR [rbp-0x10]
   1855b4a48:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1855b4a4c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1855b4a53:	72 1f                	jb     0x1855b4a74
   1855b4a55:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1855b4a59:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1855b4a5d:	4c 29 c1             	sub    rcx,r8
   1855b4a60:	48 83 f9 20          	cmp    rcx,0x20
   1855b4a64:	0f 83 12 0e 00 00    	jae    0x1855b587c
   1855b4a6a:	48 83 c0 28          	add    rax,0x28
   1855b4a6e:	48 89 c2             	mov    rdx,rax
   1855b4a71:	4c 89 c1             	mov    rcx,r8
   1855b4a74:	e8 67 6e ef 01       	call   0x1874ab8e0
   1855b4a79:	31 db                	xor    ebx,ebx
   1855b4a7b:	48 8b b5 08 01 00 00 	mov    rsi,QWORD PTR [rbp+0x108]
   1855b4a82:	48 85 f6             	test   rsi,rsi
   1855b4a85:	0f 85 9b f2 ff ff    	jne    0x1855b3d26
   1855b4a8b:	e9 d5 0d 00 00       	jmp    0x1855b5865
   1855b4a90:	48 83 fa 10          	cmp    rdx,0x10
   1855b4a94:	72 03                	jb     0x1855b4a99
   1855b4a96:	4d 8b 36             	mov    r14,QWORD PTR [r14]
   1855b4a99:	4c 89 b9 68 07 00 00 	mov    QWORD PTR [rcx+0x768],r15
   1855b4aa0:	4c 89 f1             	mov    rcx,r14
   1855b4aa3:	48 89 c2             	mov    rdx,rax
   1855b4aa6:	4d 89 f8             	mov    r8,r15
   1855b4aa9:	e8 a2 f5 f8 01       	call   0x187544050
   1855b4aae:	43 c6 04 3e 00       	mov    BYTE PTR [r14+r15*1],0x0
   1855b4ab3:	48 89 f9             	mov    rcx,rdi
   1855b4ab6:	e8 85 fb 90 fd       	call   0x182ec4640
   1855b4abb:	90                   	nop
   1855b4abc:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   1855b4ac3:	4c 8d b1 78 07 00 00 	lea    r14,[rcx+0x778]
   1855b4aca:	49 39 c6             	cmp    r14,rax
   1855b4acd:	74 4e                	je     0x1855b4b1d
   1855b4acf:	4c 8b 78 10          	mov    r15,QWORD PTR [rax+0x10]
   1855b4ad3:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   1855b4ad8:	72 03                	jb     0x1855b4add
   1855b4ada:	48 8b 00             	mov    rax,QWORD PTR [rax]
   1855b4add:	48 8b 91 90 07 00 00 	mov    rdx,QWORD PTR [rcx+0x790]
   1855b4ae4:	49 39 d7             	cmp    r15,rdx
   1855b4ae7:	76 11                	jbe    0x1855b4afa
   1855b4ae9:	4c 89 f1             	mov    rcx,r14
   1855b4aec:	4c 89 fa             	mov    rdx,r15
   1855b4aef:	49 89 c1             	mov    r9,rax
   1855b4af2:	e8 59 96 a8 fa       	call   0x18003e150
   1855b4af7:	90                   	nop
   1855b4af8:	eb 23                	jmp    0x1855b4b1d
   1855b4afa:	48 83 fa 10          	cmp    rdx,0x10
   1855b4afe:	72 03                	jb     0x1855b4b03
   1855b4b00:	4d 8b 36             	mov    r14,QWORD PTR [r14]
   1855b4b03:	4c 89 b9 88 07 00 00 	mov    QWORD PTR [rcx+0x788],r15
   1855b4b0a:	4c 89 f1             	mov    rcx,r14
   1855b4b0d:	48 89 c2             	mov    rdx,rax
   1855b4b10:	4d 89 f8             	mov    r8,r15
   1855b4b13:	e8 38 f5 f8 01       	call   0x187544050
   1855b4b18:	43 c6 04 3e 00       	mov    BYTE PTR [r14+r15*1],0x0
   1855b4b1d:	48 89 f9             	mov    rcx,rdi
   1855b4b20:	e8 bb 09 91 fd       	call   0x182ec54e0
   1855b4b25:	90                   	nop
   1855b4b26:	48 85 c0             	test   rax,rax
   1855b4b29:	74 36                	je     0x1855b4b61
   1855b4b2b:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b4b2f:	41 b8 02 00 00 00    	mov    r8d,0x2
   1855b4b35:	48 89 c2             	mov    rdx,rax
   1855b4b38:	45 31 c9             	xor    r9d,r9d
   1855b4b3b:	e8 f0 ed fa fe       	call   0x184563930
   1855b4b40:	90                   	nop
   1855b4b41:	b9 10 09 00 00       	mov    ecx,0x910
   1855b4b46:	48 03 8d 00 01 00 00 	add    rcx,QWORD PTR [rbp+0x100]
   1855b4b4d:	48 8d 7d f0          	lea    rdi,[rbp-0x10]
   1855b4b51:	48 89 fa             	mov    rdx,rdi
   1855b4b54:	e8 e7 6a ae fa       	call   0x18009b640
   1855b4b59:	48 89 f9             	mov    rcx,rdi
   1855b4b5c:	e8 ff 2e a5 fa       	call   0x180007a60
   1855b4b61:	49 89 df             	mov    r15,rbx
   1855b4b64:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b4b6b:	48 8d b8 08 08 00 00 	lea    rdi,[rax+0x808]
   1855b4b72:	48 39 df             	cmp    rdi,rbx
   1855b4b75:	74 4e                	je     0x1855b4bc5
   1855b4b77:	4d 8b 77 10          	mov    r14,QWORD PTR [r15+0x10]
   1855b4b7b:	49 83 7f 18 10       	cmp    QWORD PTR [r15+0x18],0x10
   1855b4b80:	4d 89 f9             	mov    r9,r15
   1855b4b83:	72 03                	jb     0x1855b4b88
   1855b4b85:	4d 8b 0f             	mov    r9,QWORD PTR [r15]
   1855b4b88:	48 8b 88 20 08 00 00 	mov    rcx,QWORD PTR [rax+0x820]
   1855b4b8f:	49 39 ce             	cmp    r14,rcx
   1855b4b92:	76 0e                	jbe    0x1855b4ba2
   1855b4b94:	48 89 f9             	mov    rcx,rdi
   1855b4b97:	4c 89 f2             	mov    rdx,r14
   1855b4b9a:	e8 b1 95 a8 fa       	call   0x18003e150
   1855b4b9f:	90                   	nop
   1855b4ba0:	eb 23                	jmp    0x1855b4bc5
   1855b4ba2:	48 83 f9 10          	cmp    rcx,0x10
   1855b4ba6:	72 03                	jb     0x1855b4bab
   1855b4ba8:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b4bab:	4c 89 b0 18 08 00 00 	mov    QWORD PTR [rax+0x818],r14
   1855b4bb2:	48 89 f9             	mov    rcx,rdi
   1855b4bb5:	4c 89 ca             	mov    rdx,r9
   1855b4bb8:	4d 89 f0             	mov    r8,r14
   1855b4bbb:	e8 90 f4 f8 01       	call   0x187544050
   1855b4bc0:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b4bc5:	4c 8d 8b 80 00 00 00 	lea    r9,[rbx+0x80]
   1855b4bcc:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b4bd3:	48 8d b8 e8 07 00 00 	lea    rdi,[rax+0x7e8]
   1855b4bda:	4c 39 cf             	cmp    rdi,r9
   1855b4bdd:	74 55                	je     0x1855b4c34
   1855b4bdf:	4d 8b b7 90 00 00 00 	mov    r14,QWORD PTR [r15+0x90]
   1855b4be6:	49 83 bf 98 00 00 00 	cmp    QWORD PTR [r15+0x98],0x10
   1855b4bed:	10 
   1855b4bee:	72 07                	jb     0x1855b4bf7
   1855b4bf0:	4d 8b 8f 80 00 00 00 	mov    r9,QWORD PTR [r15+0x80]
   1855b4bf7:	48 8b 88 00 08 00 00 	mov    rcx,QWORD PTR [rax+0x800]
   1855b4bfe:	49 39 ce             	cmp    r14,rcx
   1855b4c01:	76 0e                	jbe    0x1855b4c11
   1855b4c03:	48 89 f9             	mov    rcx,rdi
   1855b4c06:	4c 89 f2             	mov    rdx,r14
   1855b4c09:	e8 42 95 a8 fa       	call   0x18003e150
   1855b4c0e:	90                   	nop
   1855b4c0f:	eb 23                	jmp    0x1855b4c34
   1855b4c11:	48 83 f9 10          	cmp    rcx,0x10
   1855b4c15:	72 03                	jb     0x1855b4c1a
   1855b4c17:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b4c1a:	4c 89 b0 f8 07 00 00 	mov    QWORD PTR [rax+0x7f8],r14
   1855b4c21:	48 89 f9             	mov    rcx,rdi
   1855b4c24:	4c 89 ca             	mov    rdx,r9
   1855b4c27:	4d 89 f0             	mov    r8,r14
   1855b4c2a:	e8 21 f4 f8 01       	call   0x187544050
   1855b4c2f:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b4c34:	4c 8d 4b 60          	lea    r9,[rbx+0x60]
   1855b4c38:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b4c3f:	48 8d b8 98 07 00 00 	lea    rdi,[rax+0x798]
   1855b4c46:	4c 39 cf             	cmp    rdi,r9
   1855b4c49:	74 4c                	je     0x1855b4c97
   1855b4c4b:	4d 8b 77 70          	mov    r14,QWORD PTR [r15+0x70]
   1855b4c4f:	49 83 7f 78 10       	cmp    QWORD PTR [r15+0x78],0x10
   1855b4c54:	72 04                	jb     0x1855b4c5a
   1855b4c56:	4d 8b 4f 60          	mov    r9,QWORD PTR [r15+0x60]
   1855b4c5a:	48 8b 88 b0 07 00 00 	mov    rcx,QWORD PTR [rax+0x7b0]
   1855b4c61:	49 39 ce             	cmp    r14,rcx
   1855b4c64:	76 0e                	jbe    0x1855b4c74
   1855b4c66:	48 89 f9             	mov    rcx,rdi
   1855b4c69:	4c 89 f2             	mov    rdx,r14
   1855b4c6c:	e8 df 94 a8 fa       	call   0x18003e150
   1855b4c71:	90                   	nop
   1855b4c72:	eb 23                	jmp    0x1855b4c97
   1855b4c74:	48 83 f9 10          	cmp    rcx,0x10
   1855b4c78:	72 03                	jb     0x1855b4c7d
   1855b4c7a:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b4c7d:	4c 89 b0 a8 07 00 00 	mov    QWORD PTR [rax+0x7a8],r14
   1855b4c84:	48 89 f9             	mov    rcx,rdi
   1855b4c87:	4c 89 ca             	mov    rdx,r9
   1855b4c8a:	4d 89 f0             	mov    r8,r14
   1855b4c8d:	e8 be f3 f8 01       	call   0x187544050
   1855b4c92:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b4c97:	4c 8d 4b 40          	lea    r9,[rbx+0x40]
   1855b4c9b:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b4ca2:	48 8d b8 28 08 00 00 	lea    rdi,[rax+0x828]
   1855b4ca9:	4c 39 cf             	cmp    rdi,r9
   1855b4cac:	74 4c                	je     0x1855b4cfa
   1855b4cae:	4d 8b 77 50          	mov    r14,QWORD PTR [r15+0x50]
   1855b4cb2:	49 83 7f 58 10       	cmp    QWORD PTR [r15+0x58],0x10
   1855b4cb7:	72 04                	jb     0x1855b4cbd
   1855b4cb9:	4d 8b 4f 40          	mov    r9,QWORD PTR [r15+0x40]
   1855b4cbd:	48 8b 88 40 08 00 00 	mov    rcx,QWORD PTR [rax+0x840]
   1855b4cc4:	49 39 ce             	cmp    r14,rcx
   1855b4cc7:	76 0e                	jbe    0x1855b4cd7
   1855b4cc9:	48 89 f9             	mov    rcx,rdi
   1855b4ccc:	4c 89 f2             	mov    rdx,r14
   1855b4ccf:	e8 7c 94 a8 fa       	call   0x18003e150
   1855b4cd4:	90                   	nop
   1855b4cd5:	eb 23                	jmp    0x1855b4cfa
   1855b4cd7:	48 83 f9 10          	cmp    rcx,0x10
   1855b4cdb:	72 03                	jb     0x1855b4ce0
   1855b4cdd:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b4ce0:	4c 89 b0 38 08 00 00 	mov    QWORD PTR [rax+0x838],r14
   1855b4ce7:	48 89 f9             	mov    rcx,rdi
   1855b4cea:	4c 89 ca             	mov    rdx,r9
   1855b4ced:	4d 89 f0             	mov    r8,r14
   1855b4cf0:	e8 5b f3 f8 01       	call   0x187544050
   1855b4cf5:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b4cfa:	41 8b 8f a0 00 00 00 	mov    ecx,DWORD PTR [r15+0xa0]
   1855b4d01:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b4d08:	89 88 48 08 00 00    	mov    DWORD PTR [rax+0x848],ecx
   1855b4d0e:	41 8b 8f a8 00 00 00 	mov    ecx,DWORD PTR [r15+0xa8]
   1855b4d15:	89 88 4c 08 00 00    	mov    DWORD PTR [rax+0x84c],ecx
   1855b4d1b:	48 83 c3 20          	add    rbx,0x20
   1855b4d1f:	48 8d b8 58 08 00 00 	lea    rdi,[rax+0x858]
   1855b4d26:	48 39 df             	cmp    rdi,rbx
   1855b4d29:	74 4f                	je     0x1855b4d7a
   1855b4d2b:	4d 8b 77 30          	mov    r14,QWORD PTR [r15+0x30]
   1855b4d2f:	49 83 7f 38 10       	cmp    QWORD PTR [r15+0x38],0x10
   1855b4d34:	49 89 d9             	mov    r9,rbx
   1855b4d37:	72 04                	jb     0x1855b4d3d
   1855b4d39:	4d 8b 4f 20          	mov    r9,QWORD PTR [r15+0x20]
   1855b4d3d:	48 8b 88 70 08 00 00 	mov    rcx,QWORD PTR [rax+0x870]
   1855b4d44:	49 39 ce             	cmp    r14,rcx
   1855b4d47:	76 0e                	jbe    0x1855b4d57
   1855b4d49:	48 89 f9             	mov    rcx,rdi
   1855b4d4c:	4c 89 f2             	mov    rdx,r14
   1855b4d4f:	e8 fc 93 a8 fa       	call   0x18003e150
   1855b4d54:	90                   	nop
   1855b4d55:	eb 23                	jmp    0x1855b4d7a
   1855b4d57:	48 83 f9 10          	cmp    rcx,0x10
   1855b4d5b:	72 03                	jb     0x1855b4d60
   1855b4d5d:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b4d60:	4c 89 b0 68 08 00 00 	mov    QWORD PTR [rax+0x868],r14
   1855b4d67:	48 89 f9             	mov    rcx,rdi
   1855b4d6a:	4c 89 ca             	mov    rdx,r9
   1855b4d6d:	4d 89 f0             	mov    r8,r14
   1855b4d70:	e8 db f2 f8 01       	call   0x187544050
   1855b4d75:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b4d7a:	41 8b 8f ac 00 00 00 	mov    ecx,DWORD PTR [r15+0xac]
   1855b4d81:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b4d88:	89 88 78 08 00 00    	mov    DWORD PTR [rax+0x878],ecx
   1855b4d8e:	41 8b 8f a4 00 00 00 	mov    ecx,DWORD PTR [r15+0xa4]
   1855b4d95:	89 88 a0 08 00 00    	mov    DWORD PTR [rax+0x8a0],ecx
   1855b4d9b:	48 8d b8 f0 08 00 00 	lea    rdi,[rax+0x8f0]
   1855b4da2:	48 39 df             	cmp    rdi,rbx
   1855b4da5:	74 4f                	je     0x1855b4df6
   1855b4da7:	4d 8b 77 30          	mov    r14,QWORD PTR [r15+0x30]
   1855b4dab:	49 83 7f 38 10       	cmp    QWORD PTR [r15+0x38],0x10
   1855b4db0:	72 04                	jb     0x1855b4db6
   1855b4db2:	49 8b 5f 20          	mov    rbx,QWORD PTR [r15+0x20]
   1855b4db6:	48 8b 88 08 09 00 00 	mov    rcx,QWORD PTR [rax+0x908]
   1855b4dbd:	49 39 ce             	cmp    r14,rcx
   1855b4dc0:	76 11                	jbe    0x1855b4dd3
   1855b4dc2:	48 89 f9             	mov    rcx,rdi
   1855b4dc5:	4c 89 f2             	mov    rdx,r14
   1855b4dc8:	49 89 d9             	mov    r9,rbx
   1855b4dcb:	e8 80 93 a8 fa       	call   0x18003e150
   1855b4dd0:	90                   	nop
   1855b4dd1:	eb 23                	jmp    0x1855b4df6
   1855b4dd3:	48 83 f9 10          	cmp    rcx,0x10
   1855b4dd7:	72 03                	jb     0x1855b4ddc
   1855b4dd9:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1855b4ddc:	4c 89 b0 00 09 00 00 	mov    QWORD PTR [rax+0x900],r14
   1855b4de3:	48 89 f9             	mov    rcx,rdi
   1855b4de6:	48 89 da             	mov    rdx,rbx
   1855b4de9:	4d 89 f0             	mov    r8,r14
   1855b4dec:	e8 5f f2 f8 01       	call   0x187544050
   1855b4df1:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   1855b4df6:	48 8b 85 08 01 00 00 	mov    rax,QWORD PTR [rbp+0x108]
   1855b4dfd:	48 85 c0             	test   rax,rax
   1855b4e00:	0f 84 b4 e9 ff ff    	je     0x1855b37ba
   1855b4e06:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1855b4e0a:	48 8b 85 08 01 00 00 	mov    rax,QWORD PTR [rbp+0x108]
   1855b4e11:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   1855b4e18:	49 89 4d 00          	mov    QWORD PTR [r13+0x0],rcx
   1855b4e1c:	49 8b 7d 08          	mov    rdi,QWORD PTR [r13+0x8]
   1855b4e20:	49 89 45 08          	mov    QWORD PTR [r13+0x8],rax
   1855b4e24:	48 85 ff             	test   rdi,rdi
   1855b4e27:	0f 84 0d 0a 00 00    	je     0x1855b583a
   1855b4e2d:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1855b4e31:	0f 85 03 0a 00 00    	jne    0x1855b583a
   1855b4e37:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b4e3a:	48 89 f9             	mov    rcx,rdi
   1855b4e3d:	ff 10                	call   QWORD PTR [rax]
   1855b4e3f:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1855b4e43:	0f 85 f1 09 00 00    	jne    0x1855b583a
   1855b4e49:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b4e4c:	48 89 f9             	mov    rcx,rdi
   1855b4e4f:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b4e52:	e9 e3 09 00 00       	jmp    0x1855b583a
   1855b4e57:	b9 04 00 00 00       	mov    ecx,0x4
   1855b4e5c:	e8 7f 7f ab fa       	call   0x18006cde0
   1855b4e61:	bb 01 00 00 00       	mov    ebx,0x1
   1855b4e66:	85 c0                	test   eax,eax
   1855b4e68:	0f 84 f7 09 00 00    	je     0x1855b5865
   1855b4e6e:	48 8d b5 80 00 00 00 	lea    rsi,[rbp+0x80]
   1855b4e75:	48 89 f1             	mov    rcx,rsi
   1855b4e78:	e8 93 80 ab fa       	call   0x18006cf10
   1855b4e7d:	48 83 bd 98 00 00 00 	cmp    QWORD PTR [rbp+0x98],0x10
   1855b4e84:	10 
   1855b4e85:	72 07                	jb     0x1855b4e8e
   1855b4e87:	48 8b b5 80 00 00 00 	mov    rsi,QWORD PTR [rbp+0x80]
   1855b4e8e:	48 8d 05 4b ca 26 04 	lea    rax,[rip+0x426ca4b]        # 0x1898218e0
   1855b4e95:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b4e9a:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b4ea1:	00 00 
   1855b4ea3:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b4ea8:	c7 44 24 28 e1 00 00 	mov    DWORD PTR [rsp+0x28],0xe1
   1855b4eaf:	00 
   1855b4eb0:	4c 8d 0d 89 ca 26 04 	lea    r9,[rip+0x426ca89]        # 0x189821940
   1855b4eb7:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b4ebb:	ba 04 00 00 00       	mov    edx,0x4
   1855b4ec0:	49 89 f0             	mov    r8,rsi
   1855b4ec3:	e8 a8 83 ab fa       	call   0x18006d270
   1855b4ec8:	90                   	nop
   1855b4ec9:	0f 57 c0             	xorps  xmm0,xmm0
   1855b4ecc:	0f 29 85 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm0
   1855b4ed3:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   1855b4eda:	0f 29 85 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm0
   1855b4ee1:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   1855b4ee8:	0f 29 85 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm0
   1855b4eef:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   1855b4ef6:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   1855b4efd:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1855b4f04:	48 8d 15 7d cb 26 04 	lea    rdx,[rip+0x426cb7d]        # 0x189821a88
   1855b4f0b:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b4f0f:	4c 8d 85 00 01 00 00 	lea    r8,[rbp+0x100]
   1855b4f16:	e8 f5 88 ab fa       	call   0x18006d810
   1855b4f1b:	90                   	nop
   1855b4f1c:	e9 c5 00 00 00       	jmp    0x1855b4fe6
   1855b4f21:	b9 04 00 00 00       	mov    ecx,0x4
   1855b4f26:	e8 b5 7e ab fa       	call   0x18006cde0
   1855b4f2b:	bb 01 00 00 00       	mov    ebx,0x1
   1855b4f30:	85 c0                	test   eax,eax
   1855b4f32:	0f 84 2d 09 00 00    	je     0x1855b5865
   1855b4f38:	48 8d b5 80 00 00 00 	lea    rsi,[rbp+0x80]
   1855b4f3f:	48 89 f1             	mov    rcx,rsi
   1855b4f42:	e8 c9 7f ab fa       	call   0x18006cf10
   1855b4f47:	48 83 bd 98 00 00 00 	cmp    QWORD PTR [rbp+0x98],0x10
   1855b4f4e:	10 
   1855b4f4f:	72 07                	jb     0x1855b4f58
   1855b4f51:	48 8b b5 80 00 00 00 	mov    rsi,QWORD PTR [rbp+0x80]
   1855b4f58:	48 8d 05 81 c9 26 04 	lea    rax,[rip+0x426c981]        # 0x1898218e0
   1855b4f5f:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b4f64:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b4f6b:	00 00 
   1855b4f6d:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b4f72:	c7 44 24 28 f7 00 00 	mov    DWORD PTR [rsp+0x28],0xf7
   1855b4f79:	00 
   1855b4f7a:	4c 8d 0d bf c9 26 04 	lea    r9,[rip+0x426c9bf]        # 0x189821940
   1855b4f81:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b4f85:	ba 04 00 00 00       	mov    edx,0x4
   1855b4f8a:	49 89 f0             	mov    r8,rsi
   1855b4f8d:	e8 de 82 ab fa       	call   0x18006d270
   1855b4f92:	90                   	nop
   1855b4f93:	0f 57 c0             	xorps  xmm0,xmm0
   1855b4f96:	0f 29 85 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm0
   1855b4f9d:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   1855b4fa4:	0f 29 85 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm0
   1855b4fab:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   1855b4fb2:	0f 29 85 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm0
   1855b4fb9:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   1855b4fc0:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   1855b4fc7:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1855b4fce:	48 8d 15 b3 ca 26 04 	lea    rdx,[rip+0x426cab3]        # 0x189821a88
   1855b4fd5:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b4fd9:	4c 8d 85 00 01 00 00 	lea    r8,[rbp+0x100]
   1855b4fe0:	e8 2b 88 ab fa       	call   0x18006d810
   1855b4fe5:	90                   	nop
   1855b4fe6:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b4fea:	e8 81 83 ab fa       	call   0x18006d370
   1855b4fef:	48 8d 8d 80 00 00 00 	lea    rcx,[rbp+0x80]
   1855b4ff6:	e8 15 d0 a4 fa       	call   0x180002010
   1855b4ffb:	e9 65 08 00 00       	jmp    0x1855b5865
   1855b5000:	48 83 f9 10          	cmp    rcx,0x10
   1855b5004:	72 07                	jb     0x1855b500d
   1855b5006:	4c 8b a5 80 00 00 00 	mov    r12,QWORD PTR [rbp+0x80]
   1855b500d:	4c 89 bd 90 00 00 00 	mov    QWORD PTR [rbp+0x90],r15
   1855b5014:	4c 89 e1             	mov    rcx,r12
   1855b5017:	48 89 c2             	mov    rdx,rax
   1855b501a:	4d 89 f8             	mov    r8,r15
   1855b501d:	e8 2e f0 f8 01       	call   0x187544050
   1855b5022:	43 c6 04 3c 00       	mov    BYTE PTR [r12+r15*1],0x0
   1855b5027:	48 83 bd 90 00 00 00 	cmp    QWORD PTR [rbp+0x90],0x0
   1855b502e:	00 
   1855b502f:	0f 84 83 00 00 00    	je     0x1855b50b8
   1855b5035:	0f 28 05 74 0b 79 03 	movaps xmm0,XMMWORD PTR [rip+0x3790b74]        # 0x188d45bb0
   1855b503c:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1855b5043:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   1855b504a:	e8 e1 c5 f2 fe       	call   0x1844e1630
   1855b504f:	90                   	nop
   1855b5050:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b5057:	48 b9 31 00 00 00 05 	movabs rcx,0x500000031
   1855b505e:	00 00 00 
   1855b5061:	48 89 88 18 01 00 00 	mov    QWORD PTR [rax+0x118],rcx
   1855b5068:	4c 8d b8 e8 07 00 00 	lea    r15,[rax+0x7e8]
   1855b506f:	4c 8d 8d 80 00 00 00 	lea    r9,[rbp+0x80]
   1855b5076:	4d 39 cf             	cmp    r15,r9
   1855b5079:	0f 84 3c 01 00 00    	je     0x1855b51bb
   1855b507f:	4c 8b a5 90 00 00 00 	mov    r12,QWORD PTR [rbp+0x90]
   1855b5086:	48 83 bd 98 00 00 00 	cmp    QWORD PTR [rbp+0x98],0x10
   1855b508d:	10 
   1855b508e:	72 07                	jb     0x1855b5097
   1855b5090:	4c 8b 8d 80 00 00 00 	mov    r9,QWORD PTR [rbp+0x80]
   1855b5097:	48 8b 88 00 08 00 00 	mov    rcx,QWORD PTR [rax+0x800]
   1855b509e:	49 39 cc             	cmp    r12,rcx
   1855b50a1:	0f 86 f1 00 00 00    	jbe    0x1855b5198
   1855b50a7:	4c 89 f9             	mov    rcx,r15
   1855b50aa:	4c 89 e2             	mov    rdx,r12
   1855b50ad:	e8 9e 90 a8 fa       	call   0x18003e150
   1855b50b2:	90                   	nop
   1855b50b3:	e9 03 01 00 00       	jmp    0x1855b51bb
   1855b50b8:	b9 04 00 00 00       	mov    ecx,0x4
   1855b50bd:	e8 1e 7d ab fa       	call   0x18006cde0
   1855b50c2:	bb 01 00 00 00       	mov    ebx,0x1
   1855b50c7:	85 c0                	test   eax,eax
   1855b50c9:	0f 84 22 06 00 00    	je     0x1855b56f1
   1855b50cf:	48 8d b5 e0 00 00 00 	lea    rsi,[rbp+0xe0]
   1855b50d6:	48 89 f1             	mov    rcx,rsi
   1855b50d9:	e8 32 7e ab fa       	call   0x18006cf10
   1855b50de:	90                   	nop
   1855b50df:	48 83 bd f8 00 00 00 	cmp    QWORD PTR [rbp+0xf8],0x10
   1855b50e6:	10 
   1855b50e7:	72 07                	jb     0x1855b50f0
   1855b50e9:	48 8b b5 e0 00 00 00 	mov    rsi,QWORD PTR [rbp+0xe0]
   1855b50f0:	48 8d 05 e9 c7 26 04 	lea    rax,[rip+0x426c7e9]        # 0x1898218e0
   1855b50f7:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b50fc:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b5103:	00 00 
   1855b5105:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b510a:	c7 44 24 28 80 00 00 	mov    DWORD PTR [rsp+0x28],0x80
   1855b5111:	00 
   1855b5112:	4c 8d 0d 27 c8 26 04 	lea    r9,[rip+0x426c827]        # 0x189821940
   1855b5119:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b511d:	ba 04 00 00 00       	mov    edx,0x4
   1855b5122:	49 89 f0             	mov    r8,rsi
   1855b5125:	e8 46 81 ab fa       	call   0x18006d270
   1855b512a:	90                   	nop
   1855b512b:	0f 57 c0             	xorps  xmm0,xmm0
   1855b512e:	0f 29 85 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm0
   1855b5135:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   1855b513c:	0f 29 85 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm0
   1855b5143:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   1855b514a:	0f 29 85 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm0
   1855b5151:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   1855b5158:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   1855b515f:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1855b5166:	48 8d 15 bb a7 c9 03 	lea    rdx,[rip+0x3c9a7bb]        # 0x18924f928
   1855b516d:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b5171:	4c 8d 85 00 01 00 00 	lea    r8,[rbp+0x100]
   1855b5178:	e8 93 86 ab fa       	call   0x18006d810
   1855b517d:	90                   	nop
   1855b517e:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b5182:	e8 e9 81 ab fa       	call   0x18006d370
   1855b5187:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b518e:	e8 7d ce a4 fa       	call   0x180002010
   1855b5193:	e9 59 05 00 00       	jmp    0x1855b56f1
   1855b5198:	48 83 f9 10          	cmp    rcx,0x10
   1855b519c:	72 03                	jb     0x1855b51a1
   1855b519e:	4d 8b 3f             	mov    r15,QWORD PTR [r15]
   1855b51a1:	4c 89 a0 f8 07 00 00 	mov    QWORD PTR [rax+0x7f8],r12
   1855b51a8:	4c 89 f9             	mov    rcx,r15
   1855b51ab:	4c 89 ca             	mov    rdx,r9
   1855b51ae:	4d 89 e0             	mov    r8,r12
   1855b51b1:	e8 9a ee f8 01       	call   0x187544050
   1855b51b6:	43 c6 04 27 00       	mov    BYTE PTR [r15+r12*1],0x0
   1855b51bb:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1855b51be:	48 89 d9             	mov    rcx,rbx
   1855b51c1:	ff 50 18             	call   QWORD PTR [rax+0x18]
   1855b51c4:	90                   	nop
   1855b51c5:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   1855b51cc:	4c 8d b9 08 08 00 00 	lea    r15,[rcx+0x808]
   1855b51d3:	49 39 c7             	cmp    r15,rax
   1855b51d6:	74 4e                	je     0x1855b5226
   1855b51d8:	4c 8b 60 10          	mov    r12,QWORD PTR [rax+0x10]
   1855b51dc:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   1855b51e1:	72 03                	jb     0x1855b51e6
   1855b51e3:	48 8b 00             	mov    rax,QWORD PTR [rax]
   1855b51e6:	48 8b 91 20 08 00 00 	mov    rdx,QWORD PTR [rcx+0x820]
   1855b51ed:	49 39 d4             	cmp    r12,rdx
   1855b51f0:	76 11                	jbe    0x1855b5203
   1855b51f2:	4c 89 f9             	mov    rcx,r15
   1855b51f5:	4c 89 e2             	mov    rdx,r12
   1855b51f8:	49 89 c1             	mov    r9,rax
   1855b51fb:	e8 50 8f a8 fa       	call   0x18003e150
   1855b5200:	90                   	nop
   1855b5201:	eb 23                	jmp    0x1855b5226
   1855b5203:	48 83 fa 10          	cmp    rdx,0x10
   1855b5207:	72 03                	jb     0x1855b520c
   1855b5209:	4d 8b 3f             	mov    r15,QWORD PTR [r15]
   1855b520c:	4c 89 a1 18 08 00 00 	mov    QWORD PTR [rcx+0x818],r12
   1855b5213:	4c 89 f9             	mov    rcx,r15
   1855b5216:	48 89 c2             	mov    rdx,rax
   1855b5219:	4d 89 e0             	mov    r8,r12
   1855b521c:	e8 2f ee f8 01       	call   0x187544050
   1855b5221:	43 c6 04 27 00       	mov    BYTE PTR [r15+r12*1],0x0
   1855b5226:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1855b5229:	48 89 d9             	mov    rcx,rbx
   1855b522c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b522f:	90                   	nop
   1855b5230:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   1855b5237:	4c 8d b9 58 07 00 00 	lea    r15,[rcx+0x758]
   1855b523e:	49 39 c7             	cmp    r15,rax
   1855b5241:	74 4e                	je     0x1855b5291
   1855b5243:	4c 8b 60 10          	mov    r12,QWORD PTR [rax+0x10]
   1855b5247:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   1855b524c:	72 03                	jb     0x1855b5251
   1855b524e:	48 8b 00             	mov    rax,QWORD PTR [rax]
   1855b5251:	48 8b 91 70 07 00 00 	mov    rdx,QWORD PTR [rcx+0x770]
   1855b5258:	49 39 d4             	cmp    r12,rdx
   1855b525b:	76 11                	jbe    0x1855b526e
   1855b525d:	4c 89 f9             	mov    rcx,r15
   1855b5260:	4c 89 e2             	mov    rdx,r12
   1855b5263:	49 89 c1             	mov    r9,rax
   1855b5266:	e8 e5 8e a8 fa       	call   0x18003e150
   1855b526b:	90                   	nop
   1855b526c:	eb 23                	jmp    0x1855b5291
   1855b526e:	48 83 fa 10          	cmp    rdx,0x10
   1855b5272:	72 03                	jb     0x1855b5277
   1855b5274:	4d 8b 3f             	mov    r15,QWORD PTR [r15]
   1855b5277:	4c 89 a1 68 07 00 00 	mov    QWORD PTR [rcx+0x768],r12
   1855b527e:	4c 89 f9             	mov    rcx,r15
   1855b5281:	48 89 c2             	mov    rdx,rax
   1855b5284:	4d 89 e0             	mov    r8,r12
   1855b5287:	e8 c4 ed f8 01       	call   0x187544050
   1855b528c:	43 c6 04 27 00       	mov    BYTE PTR [r15+r12*1],0x0
   1855b5291:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   1855b5298:	48 8b 81 68 07 00 00 	mov    rax,QWORD PTR [rcx+0x768]
   1855b529f:	48 85 c0             	test   rax,rax
   1855b52a2:	0f 95 c2             	setne  dl
   1855b52a5:	4d 85 f6             	test   r14,r14
   1855b52a8:	41 0f 94 c0          	sete   r8b
   1855b52ac:	41 08 d0             	or     r8b,dl
   1855b52af:	75 22                	jne    0x1855b52d3
   1855b52b1:	48 81 c1 58 07 00 00 	add    rcx,0x758
   1855b52b8:	49 8d 96 90 01 00 00 	lea    rdx,[r14+0x190]
   1855b52bf:	e8 5c 01 d9 fa       	call   0x180345420
   1855b52c4:	90                   	nop
   1855b52c5:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b52cc:	48 8b 80 68 07 00 00 	mov    rax,QWORD PTR [rax+0x768]
   1855b52d3:	48 85 c0             	test   rax,rax
   1855b52d6:	75 1e                	jne    0x1855b52f6
   1855b52d8:	48 89 f9             	mov    rcx,rdi
   1855b52db:	e8 c0 f2 90 fd       	call   0x182ec45a0
   1855b52e0:	90                   	nop
   1855b52e1:	b9 58 07 00 00       	mov    ecx,0x758
   1855b52e6:	48 03 8d 00 01 00 00 	add    rcx,QWORD PTR [rbp+0x100]
   1855b52ed:	48 89 c2             	mov    rdx,rax
   1855b52f0:	e8 2b 01 d9 fa       	call   0x180345420
   1855b52f5:	90                   	nop
   1855b52f6:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1855b52f9:	48 89 d9             	mov    rcx,rbx
   1855b52fc:	ff 50 10             	call   QWORD PTR [rax+0x10]
   1855b52ff:	90                   	nop
   1855b5300:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   1855b5307:	4c 8d b9 78 07 00 00 	lea    r15,[rcx+0x778]
   1855b530e:	49 39 c7             	cmp    r15,rax
   1855b5311:	74 4e                	je     0x1855b5361
   1855b5313:	4c 8b 60 10          	mov    r12,QWORD PTR [rax+0x10]
   1855b5317:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   1855b531c:	72 03                	jb     0x1855b5321
   1855b531e:	48 8b 00             	mov    rax,QWORD PTR [rax]
   1855b5321:	48 8b 91 90 07 00 00 	mov    rdx,QWORD PTR [rcx+0x790]
   1855b5328:	49 39 d4             	cmp    r12,rdx
   1855b532b:	76 11                	jbe    0x1855b533e
   1855b532d:	4c 89 f9             	mov    rcx,r15
   1855b5330:	4c 89 e2             	mov    rdx,r12
   1855b5333:	49 89 c1             	mov    r9,rax
   1855b5336:	e8 15 8e a8 fa       	call   0x18003e150
   1855b533b:	90                   	nop
   1855b533c:	eb 23                	jmp    0x1855b5361
   1855b533e:	48 83 fa 10          	cmp    rdx,0x10
   1855b5342:	72 03                	jb     0x1855b5347
   1855b5344:	4d 8b 3f             	mov    r15,QWORD PTR [r15]
   1855b5347:	4c 89 a1 88 07 00 00 	mov    QWORD PTR [rcx+0x788],r12
   1855b534e:	4c 89 f9             	mov    rcx,r15
   1855b5351:	48 89 c2             	mov    rdx,rax
   1855b5354:	4d 89 e0             	mov    r8,r12
   1855b5357:	e8 f4 ec f8 01       	call   0x187544050
   1855b535c:	43 c6 04 27 00       	mov    BYTE PTR [r15+r12*1],0x0
   1855b5361:	4d 85 f6             	test   r14,r14
   1855b5364:	0f 94 c2             	sete   dl
   1855b5367:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   1855b536e:	48 8b 81 88 07 00 00 	mov    rax,QWORD PTR [rcx+0x788]
   1855b5375:	48 85 c0             	test   rax,rax
   1855b5378:	41 0f 95 c0          	setne  r8b
   1855b537c:	41 08 d0             	or     r8b,dl
   1855b537f:	75 25                	jne    0x1855b53a6
   1855b5381:	48 81 c1 78 07 00 00 	add    rcx,0x778
   1855b5388:	49 81 c6 b0 01 00 00 	add    r14,0x1b0
   1855b538f:	4c 89 f2             	mov    rdx,r14
   1855b5392:	e8 89 00 d9 fa       	call   0x180345420
   1855b5397:	90                   	nop
   1855b5398:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b539f:	48 8b 80 88 07 00 00 	mov    rax,QWORD PTR [rax+0x788]
   1855b53a6:	48 85 c0             	test   rax,rax
   1855b53a9:	75 1e                	jne    0x1855b53c9
   1855b53ab:	48 89 f9             	mov    rcx,rdi
   1855b53ae:	e8 8d f2 90 fd       	call   0x182ec4640
   1855b53b3:	90                   	nop
   1855b53b4:	b9 78 07 00 00       	mov    ecx,0x778
   1855b53b9:	48 03 8d 00 01 00 00 	add    rcx,QWORD PTR [rbp+0x100]
   1855b53c0:	48 89 c2             	mov    rdx,rax
   1855b53c3:	e8 58 00 d9 fa       	call   0x180345420
   1855b53c8:	90                   	nop
   1855b53c9:	48 89 f9             	mov    rcx,rdi
   1855b53cc:	e8 4f f4 90 fd       	call   0x182ec4820
   1855b53d1:	90                   	nop
   1855b53d2:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   1855b53d9:	4c 8d b1 98 07 00 00 	lea    r14,[rcx+0x798]
   1855b53e0:	49 39 c6             	cmp    r14,rax
   1855b53e3:	74 4e                	je     0x1855b5433
   1855b53e5:	4c 8b 78 10          	mov    r15,QWORD PTR [rax+0x10]
   1855b53e9:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   1855b53ee:	72 03                	jb     0x1855b53f3
   1855b53f0:	48 8b 00             	mov    rax,QWORD PTR [rax]
   1855b53f3:	48 8b 91 b0 07 00 00 	mov    rdx,QWORD PTR [rcx+0x7b0]
   1855b53fa:	49 39 d7             	cmp    r15,rdx
   1855b53fd:	76 11                	jbe    0x1855b5410
   1855b53ff:	4c 89 f1             	mov    rcx,r14
   1855b5402:	4c 89 fa             	mov    rdx,r15
   1855b5405:	49 89 c1             	mov    r9,rax
   1855b5408:	e8 43 8d a8 fa       	call   0x18003e150
   1855b540d:	90                   	nop
   1855b540e:	eb 23                	jmp    0x1855b5433
   1855b5410:	48 83 fa 10          	cmp    rdx,0x10
   1855b5414:	72 03                	jb     0x1855b5419
   1855b5416:	4d 8b 36             	mov    r14,QWORD PTR [r14]
   1855b5419:	4c 89 b9 a8 07 00 00 	mov    QWORD PTR [rcx+0x7a8],r15
   1855b5420:	4c 89 f1             	mov    rcx,r14
   1855b5423:	48 89 c2             	mov    rdx,rax
   1855b5426:	4d 89 f8             	mov    r8,r15
   1855b5429:	e8 22 ec f8 01       	call   0x187544050
   1855b542e:	43 c6 04 3e 00       	mov    BYTE PTR [r14+r15*1],0x0
   1855b5433:	48 89 f9             	mov    rcx,rdi
   1855b5436:	e8 a5 00 91 fd       	call   0x182ec54e0
   1855b543b:	90                   	nop
   1855b543c:	48 85 c0             	test   rax,rax
   1855b543f:	74 36                	je     0x1855b5477
   1855b5441:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b5445:	41 b8 02 00 00 00    	mov    r8d,0x2
   1855b544b:	48 89 c2             	mov    rdx,rax
   1855b544e:	45 31 c9             	xor    r9d,r9d
   1855b5451:	e8 da e4 fa fe       	call   0x184563930
   1855b5456:	90                   	nop
   1855b5457:	b9 68 08 00 00       	mov    ecx,0x868
   1855b545c:	48 03 8d 00 01 00 00 	add    rcx,QWORD PTR [rbp+0x100]
   1855b5463:	4c 8d 75 f0          	lea    r14,[rbp-0x10]
   1855b5467:	4c 89 f2             	mov    rdx,r14
   1855b546a:	e8 d1 61 ae fa       	call   0x18009b640
   1855b546f:	4c 89 f1             	mov    rcx,r14
   1855b5472:	e8 e9 25 a5 fa       	call   0x180007a60
   1855b5477:	0f 57 c0             	xorps  xmm0,xmm0
   1855b547a:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   1855b5481:	48 8b 43 10          	mov    rax,QWORD PTR [rbx+0x10]
   1855b5485:	48 85 c0             	test   rax,rax
   1855b5488:	74 0a                	je     0x1855b5494
   1855b548a:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1855b548e:	48 8b 43 10          	mov    rax,QWORD PTR [rbx+0x10]
   1855b5492:	eb 02                	jmp    0x1855b5496
   1855b5494:	31 c0                	xor    eax,eax
   1855b5496:	48 8b 5b 08          	mov    rbx,QWORD PTR [rbx+0x8]
   1855b549a:	48 89 9d e0 00 00 00 	mov    QWORD PTR [rbp+0xe0],rbx
   1855b54a1:	48 89 85 e8 00 00 00 	mov    QWORD PTR [rbp+0xe8],rax
   1855b54a8:	4c 8b b5 00 01 00 00 	mov    r14,QWORD PTR [rbp+0x100]
   1855b54af:	48 85 db             	test   rbx,rbx
   1855b54b2:	0f 84 6d 01 00 00    	je     0x1855b5625
   1855b54b8:	48 8d 53 08          	lea    rdx,[rbx+0x8]
   1855b54bc:	49 81 c6 28 08 00 00 	add    r14,0x828
   1855b54c3:	4c 89 f1             	mov    rcx,r14
   1855b54c6:	e8 55 ff d8 fa       	call   0x180345420
   1855b54cb:	90                   	nop
   1855b54cc:	48 8d 53 28          	lea    rdx,[rbx+0x28]
   1855b54d0:	b9 48 08 00 00       	mov    ecx,0x848
   1855b54d5:	48 03 8d 00 01 00 00 	add    rcx,QWORD PTR [rbp+0x100]
   1855b54dc:	e8 3f ff d8 fa       	call   0x180345420
   1855b54e1:	90                   	nop
   1855b54e2:	83 3b 08             	cmp    DWORD PTR [rbx],0x8
   1855b54e5:	4c 8b b5 00 01 00 00 	mov    r14,QWORD PTR [rbp+0x100]
   1855b54ec:	0f 85 33 01 00 00    	jne    0x1855b5625
   1855b54f2:	49 8b 86 c8 08 00 00 	mov    rax,QWORD PTR [r14+0x8c8]
   1855b54f9:	b9 08 00 00 00       	mov    ecx,0x8
   1855b54fe:	48 85 c0             	test   rax,rax
   1855b5501:	0f 85 b0 00 00 00    	jne    0x1855b55b7
   1855b5507:	b9 98 00 00 00       	mov    ecx,0x98
   1855b550c:	e8 8b 63 ef 01       	call   0x1874ab89c
   1855b5511:	90                   	nop
   1855b5512:	49 81 c6 c8 08 00 00 	add    r14,0x8c8
   1855b5519:	48 b9 01 00 00 00 01 	movabs rcx,0x100000001
   1855b5520:	00 00 00 
   1855b5523:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
   1855b5527:	48 8d 0d ca 04 92 03 	lea    rcx,[rip+0x39204ca]        # 0x188ed59f8
   1855b552e:	48 89 08             	mov    QWORD PTR [rax],rcx
   1855b5531:	48 89 c1             	mov    rcx,rax
   1855b5534:	48 83 c1 10          	add    rcx,0x10
   1855b5538:	0f 57 c0             	xorps  xmm0,xmm0
   1855b553b:	0f 11 40 50          	movups XMMWORD PTR [rax+0x50],xmm0
   1855b553f:	0f 11 40 60          	movups XMMWORD PTR [rax+0x60],xmm0
   1855b5543:	0f 11 40 70          	movups XMMWORD PTR [rax+0x70],xmm0
   1855b5547:	0f 11 80 80 00 00 00 	movups XMMWORD PTR [rax+0x80],xmm0
   1855b554e:	0f 11 40 10          	movups XMMWORD PTR [rax+0x10],xmm0
   1855b5552:	0f 11 40 20          	movups XMMWORD PTR [rax+0x20],xmm0
   1855b5556:	0f 11 40 30          	movups XMMWORD PTR [rax+0x30],xmm0
   1855b555a:	0f 11 40 40          	movups XMMWORD PTR [rax+0x40],xmm0
   1855b555e:	48 c7 80 90 00 00 00 	mov    QWORD PTR [rax+0x90],0x0
   1855b5565:	00 00 00 00 
   1855b5569:	48 c7 40 58 0f 00 00 	mov    QWORD PTR [rax+0x58],0xf
   1855b5570:	00 
   1855b5571:	0f 11 40 68          	movups XMMWORD PTR [rax+0x68],xmm0
   1855b5575:	48 c7 40 78 00 00 00 	mov    QWORD PTR [rax+0x78],0x0
   1855b557c:	00 
   1855b557d:	48 c7 80 80 00 00 00 	mov    QWORD PTR [rax+0x80],0xf
   1855b5584:	0f 00 00 00 
   1855b5588:	48 89 4d f0          	mov    QWORD PTR [rbp-0x10],rcx
   1855b558c:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
   1855b5590:	4c 8d 7d f0          	lea    r15,[rbp-0x10]
   1855b5594:	4c 89 f1             	mov    rcx,r14
   1855b5597:	4c 89 fa             	mov    rdx,r15
   1855b559a:	e8 11 25 4a fb       	call   0x180a57ab0
   1855b559f:	4c 89 f9             	mov    rcx,r15
   1855b55a2:	e8 b9 ca a4 fa       	call   0x180002060
   1855b55a7:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b55ae:	48 8b 80 c8 08 00 00 	mov    rax,QWORD PTR [rax+0x8c8]
   1855b55b5:	8b 0b                	mov    ecx,DWORD PTR [rbx]
   1855b55b7:	48 89 08             	mov    QWORD PTR [rax],rcx
   1855b55ba:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   1855b55c1:	4c 8b b0 c8 08 00 00 	mov    r14,QWORD PTR [rax+0x8c8]
   1855b55c8:	48 8d 55 f0          	lea    rdx,[rbp-0x10]
   1855b55cc:	48 89 d9             	mov    rcx,rbx
   1855b55cf:	e8 9c d2 02 fe       	call   0x1835e2870
   1855b55d4:	90                   	nop
   1855b55d5:	48 8d 55 f0          	lea    rdx,[rbp-0x10]
   1855b55d9:	4c 89 f1             	mov    rcx,r14
   1855b55dc:	e8 7f 89 4f fb       	call   0x180aadf60
   1855b55e1:	90                   	nop
   1855b55e2:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b55e6:	e8 25 ca a4 fa       	call   0x180002010
   1855b55eb:	4c 8b b5 00 01 00 00 	mov    r14,QWORD PTR [rbp+0x100]
   1855b55f2:	49 8b 86 c8 08 00 00 	mov    rax,QWORD PTR [r14+0x8c8]
   1855b55f9:	8b 8b b8 00 00 00    	mov    ecx,DWORD PTR [rbx+0xb8]
   1855b55ff:	89 48 78             	mov    DWORD PTR [rax+0x78],ecx
   1855b5602:	49 8b 86 c8 08 00 00 	mov    rax,QWORD PTR [r14+0x8c8]
   1855b5609:	8b 8b bc 00 00 00    	mov    ecx,DWORD PTR [rbx+0xbc]
   1855b560f:	89 48 7c             	mov    DWORD PTR [rax+0x7c],ecx
   1855b5612:	49 8b 86 c8 08 00 00 	mov    rax,QWORD PTR [r14+0x8c8]
   1855b5619:	8b 8b c0 00 00 00    	mov    ecx,DWORD PTR [rbx+0xc0]
   1855b561f:	89 88 80 00 00 00    	mov    DWORD PTR [rax+0x80],ecx
   1855b5625:	49 83 be 38 08 00 00 	cmp    QWORD PTR [r14+0x838],0x0
   1855b562c:	00 
   1855b562d:	75 1e                	jne    0x1855b564d
   1855b562f:	48 89 f9             	mov    rcx,rdi
   1855b5632:	e8 a9 f2 90 fd       	call   0x182ec48e0
   1855b5637:	90                   	nop
   1855b5638:	b9 28 08 00 00       	mov    ecx,0x828
   1855b563d:	48 03 8d 00 01 00 00 	add    rcx,QWORD PTR [rbp+0x100]
   1855b5644:	48 89 c2             	mov    rdx,rax
   1855b5647:	e8 d4 fd d8 fa       	call   0x180345420
   1855b564c:	90                   	nop
   1855b564d:	48 8b 85 08 01 00 00 	mov    rax,QWORD PTR [rbp+0x108]
   1855b5654:	48 85 c0             	test   rax,rax
   1855b5657:	74 0d                	je     0x1855b5666
   1855b5659:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1855b565d:	48 8b 85 08 01 00 00 	mov    rax,QWORD PTR [rbp+0x108]
   1855b5664:	eb 02                	jmp    0x1855b5668
   1855b5666:	31 c0                	xor    eax,eax
   1855b5668:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   1855b566f:	49 89 4d 00          	mov    QWORD PTR [r13+0x0],rcx
   1855b5673:	49 8b 7d 08          	mov    rdi,QWORD PTR [r13+0x8]
   1855b5677:	49 89 45 08          	mov    QWORD PTR [r13+0x8],rax
   1855b567b:	48 85 ff             	test   rdi,rdi
   1855b567e:	74 1d                	je     0x1855b569d
   1855b5680:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1855b5684:	75 17                	jne    0x1855b569d
   1855b5686:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b5689:	48 89 f9             	mov    rcx,rdi
   1855b568c:	ff 10                	call   QWORD PTR [rax]
   1855b568e:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1855b5692:	75 09                	jne    0x1855b569d
   1855b5694:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b5697:	48 89 f9             	mov    rcx,rdi
   1855b569a:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b569d:	48 8b b5 e8 00 00 00 	mov    rsi,QWORD PTR [rbp+0xe8]
   1855b56a4:	48 85 f6             	test   rsi,rsi
   1855b56a7:	74 1d                	je     0x1855b56c6
   1855b56a9:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1855b56ad:	75 17                	jne    0x1855b56c6
   1855b56af:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b56b2:	48 89 f1             	mov    rcx,rsi
   1855b56b5:	ff 10                	call   QWORD PTR [rax]
   1855b56b7:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1855b56bb:	75 09                	jne    0x1855b56c6
   1855b56bd:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b56c0:	48 89 f1             	mov    rcx,rsi
   1855b56c3:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b56c6:	48 8b b5 08 01 00 00 	mov    rsi,QWORD PTR [rbp+0x108]
   1855b56cd:	48 85 f6             	test   rsi,rsi
   1855b56d0:	74 1d                	je     0x1855b56ef
   1855b56d2:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1855b56d6:	75 17                	jne    0x1855b56ef
   1855b56d8:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b56db:	48 89 f1             	mov    rcx,rsi
   1855b56de:	ff 10                	call   QWORD PTR [rax]
   1855b56e0:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1855b56e4:	75 09                	jne    0x1855b56ef
   1855b56e6:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b56e9:	48 89 f1             	mov    rcx,rsi
   1855b56ec:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b56ef:	31 db                	xor    ebx,ebx
   1855b56f1:	48 8b 85 98 00 00 00 	mov    rax,QWORD PTR [rbp+0x98]
   1855b56f8:	48 83 f8 10          	cmp    rax,0x10
   1855b56fc:	0f 82 63 01 00 00    	jb     0x1855b5865
   1855b5702:	48 8b 8d 80 00 00 00 	mov    rcx,QWORD PTR [rbp+0x80]
   1855b5709:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1855b570d:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1855b5714:	72 1f                	jb     0x1855b5735
   1855b5716:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1855b571a:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1855b571e:	4c 29 c1             	sub    rcx,r8
   1855b5721:	48 83 f9 20          	cmp    rcx,0x20
   1855b5725:	0f 83 51 01 00 00    	jae    0x1855b587c
   1855b572b:	48 83 c0 28          	add    rax,0x28
   1855b572f:	48 89 c2             	mov    rdx,rax
   1855b5732:	4c 89 c1             	mov    rcx,r8
   1855b5735:	e8 a6 61 ef 01       	call   0x1874ab8e0
   1855b573a:	e9 26 01 00 00       	jmp    0x1855b5865
   1855b573f:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b5743:	e8 18 c9 a4 fa       	call   0x180002060
   1855b5748:	bb 01 00 00 00       	mov    ebx,0x1
   1855b574d:	e9 13 01 00 00       	jmp    0x1855b5865
   1855b5752:	49 8d 4d 01          	lea    rcx,[r13+0x1]
   1855b5756:	e8 41 61 ef 01       	call   0x1874ab89c
   1855b575b:	90                   	nop
   1855b575c:	49 89 c4             	mov    r12,rax
   1855b575f:	48 8b 8d d8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xd8]
   1855b5766:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
   1855b576a:	4c 89 65 f0          	mov    QWORD PTR [rbp-0x10],r12
   1855b576e:	48 83 fa 10          	cmp    rdx,0x10
   1855b5772:	48 0f 43 f9          	cmovae rdi,rcx
   1855b5776:	48 89 75 00          	mov    QWORD PTR [rbp+0x0],rsi
   1855b577a:	4c 89 6d 08          	mov    QWORD PTR [rbp+0x8],r13
   1855b577e:	4c 89 e1             	mov    rcx,r12
   1855b5781:	48 89 da             	mov    rdx,rbx
   1855b5784:	4d 89 f8             	mov    r8,r15
   1855b5787:	e8 c4 e8 f8 01       	call   0x187544050
   1855b578c:	4d 01 e7             	add    r15,r12
   1855b578f:	4c 89 f9             	mov    rcx,r15
   1855b5792:	48 89 fa             	mov    rdx,rdi
   1855b5795:	4d 89 f0             	mov    r8,r14
   1855b5798:	e8 b3 e8 f8 01       	call   0x187544050
   1855b579d:	41 c6 04 34 00       	mov    BYTE PTR [r12+rsi*1],0x0
   1855b57a2:	48 8b b5 00 01 00 00 	mov    rsi,QWORD PTR [rbp+0x100]
   1855b57a9:	48 8b 86 70 07 00 00 	mov    rax,QWORD PTR [rsi+0x770]
   1855b57b0:	48 81 c6 58 07 00 00 	add    rsi,0x758
   1855b57b7:	48 83 f8 10          	cmp    rax,0x10
   1855b57bb:	48 8b 5d e8          	mov    rbx,QWORD PTR [rbp-0x18]
   1855b57bf:	72 34                	jb     0x1855b57f5
   1855b57c1:	48 8b 0e             	mov    rcx,QWORD PTR [rsi]
   1855b57c4:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1855b57c8:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1855b57cf:	72 1f                	jb     0x1855b57f0
   1855b57d1:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1855b57d5:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1855b57d9:	4c 29 c1             	sub    rcx,r8
   1855b57dc:	48 83 f9 20          	cmp    rcx,0x20
   1855b57e0:	0f 83 96 00 00 00    	jae    0x1855b587c
   1855b57e6:	48 83 c0 28          	add    rax,0x28
   1855b57ea:	48 89 c2             	mov    rdx,rax
   1855b57ed:	4c 89 c1             	mov    rcx,r8
   1855b57f0:	e8 eb 60 ef 01       	call   0x1874ab8e0
   1855b57f5:	0f 28 45 f0          	movaps xmm0,XMMWORD PTR [rbp-0x10]
   1855b57f9:	0f 28 4d 00          	movaps xmm1,XMMWORD PTR [rbp+0x0]
   1855b57fd:	0f 11 4e 10          	movups XMMWORD PTR [rsi+0x10],xmm1
   1855b5801:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   1855b5804:	48 8b 85 08 01 00 00 	mov    rax,QWORD PTR [rbp+0x108]
   1855b580b:	48 85 c0             	test   rax,rax
   1855b580e:	74 0d                	je     0x1855b581d
   1855b5810:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1855b5814:	48 8b 85 08 01 00 00 	mov    rax,QWORD PTR [rbp+0x108]
   1855b581b:	eb 02                	jmp    0x1855b581f
   1855b581d:	31 c0                	xor    eax,eax
   1855b581f:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   1855b5826:	48 89 0b             	mov    QWORD PTR [rbx],rcx
   1855b5829:	48 8b 7b 08          	mov    rdi,QWORD PTR [rbx+0x8]
   1855b582d:	48 89 43 08          	mov    QWORD PTR [rbx+0x8],rax
   1855b5831:	48 85 ff             	test   rdi,rdi
   1855b5834:	0f 85 f3 f5 ff ff    	jne    0x1855b4e2d
   1855b583a:	48 8b b5 08 01 00 00 	mov    rsi,QWORD PTR [rbp+0x108]
   1855b5841:	48 85 f6             	test   rsi,rsi
   1855b5844:	74 1d                	je     0x1855b5863
   1855b5846:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1855b584a:	75 17                	jne    0x1855b5863
   1855b584c:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b584f:	48 89 f1             	mov    rcx,rsi
   1855b5852:	ff 10                	call   QWORD PTR [rax]
   1855b5854:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1855b5858:	75 09                	jne    0x1855b5863
   1855b585a:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b585d:	48 89 f1             	mov    rcx,rsi
   1855b5860:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b5863:	31 db                	xor    ebx,ebx
   1855b5865:	48 89 d8             	mov    rax,rbx
   1855b5868:	48 81 c4 08 02 00 00 	add    rsp,0x208
   1855b586f:	5b                   	pop    rbx
   1855b5870:	5f                   	pop    rdi
   1855b5871:	5e                   	pop    rsi
   1855b5872:	41 5c                	pop    r12
   1855b5874:	41 5d                	pop    r13
   1855b5876:	41 5e                	pop    r14
   1855b5878:	41 5f                	pop    r15
   1855b587a:	5d                   	pop    rbp
   1855b587b:	c3                   	ret
   1855b587c:	e8 0b 7b f5 01       	call   0x18750d38c
   1855b5881:	e8 0a 33 a5 fa       	call   0x180008b90
   1855b5886:	90                   	nop
   1855b5887:	e8 04 33 a5 fa       	call   0x180008b90
   1855b588c:	90                   	nop
   1855b588d:	e8 fe 32 a5 fa       	call   0x180008b90
   1855b5892:	90                   	nop
   1855b5893:	cc                   	int3
