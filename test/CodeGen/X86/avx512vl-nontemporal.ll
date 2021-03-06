; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=skx --show-mc-encoding | FileCheck %s

define i32 @f256(<8 x float> %A, <8 x float> %AA, i8* %B, <4 x double> %C, <4 x double> %CC, i32 %D, <4 x i64> %E, <4 x i64> %EE, i32* %loadptr) {
; CHECK: vmovntps %ymm{{.*}} ## EVEX TO VEX Compression encoding: [0xc5
  %v0 = load i32, i32* %loadptr, align 1
  %cast = bitcast i8* %B to <8 x float>*
  %A2 = fadd <8 x float> %A, %AA
  store <8 x float> %A2, <8 x float>* %cast, align 64, !nontemporal !0
; CHECK: vmovntdq %ymm{{.*}} ## EVEX TO VEX Compression encoding: [0xc5
  %v1 = load i32, i32* %loadptr, align 1
  %cast1 = bitcast i8* %B to <4 x i64>*
  %E2 = add <4 x i64> %E, %EE
  store <4 x i64> %E2, <4 x i64>* %cast1, align 64, !nontemporal !0
; CHECK: vmovntpd %ymm{{.*}} ## EVEX TO VEX Compression encoding: [0xc5
  %v2 = load i32, i32* %loadptr, align 1
  %cast2 = bitcast i8* %B to <4 x double>*
  %C2 = fadd <4 x double> %C, %CC
  store <4 x double> %C2, <4 x double>* %cast2, align 64, !nontemporal !0
  %v3 = load i32, i32* %loadptr, align 1
  %sum1 = add i32 %v0, %v1
  %sum2 = add i32 %sum1, %v2
  %sum3 = add i32 %sum2, %v3
  ret i32 %sum3
}

define i32  @f128(<4 x float> %A, <4 x float> %AA, i8* %B, <2 x double> %C, <2 x double> %CC, i32 %D, <2 x i64> %E, <2 x i64> %EE, i32* %loadptr) {
  %v0 = load i32, i32* %loadptr, align 1
; CHECK: vmovntps %xmm{{.*}} ## EVEX TO VEX Compression encoding: [0xc5
  %cast = bitcast i8* %B to <4 x float>*
  %A2 = fadd <4 x float> %A, %AA
  store <4 x float> %A2, <4 x float>* %cast, align 64, !nontemporal !0
; CHECK: vmovntdq %xmm{{.*}} ## EVEX TO VEX Compression encoding: [0xc5
  %v1 = load i32, i32* %loadptr, align 1
  %cast1 = bitcast i8* %B to <2 x i64>*
  %E2 = add <2 x i64> %E, %EE
  store <2 x i64> %E2, <2 x i64>* %cast1, align 64, !nontemporal !0
; CHECK: vmovntpd %xmm{{.*}} ## EVEX TO VEX Compression encoding: [0xc5
  %v2 = load i32, i32* %loadptr, align 1
  %cast2 = bitcast i8* %B to <2 x double>*
  %C2 = fadd <2 x double> %C, %CC
  store <2 x double> %C2, <2 x double>* %cast2, align 64, !nontemporal !0
  %v3 = load i32, i32* %loadptr, align 1
  %sum1 = add i32 %v0, %v1
  %sum2 = add i32 %sum1, %v2
  %sum3 = add i32 %sum2, %v3
  ret i32 %sum3
}
!0 = !{i32 1}
