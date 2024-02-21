//
//  ContentView.swift
//  MyCamera
//
//  Created by ゆり on 2024/02/17.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ContentView: View {
    // 撮影した写真を保持する状態変数
    @State var captureImage: UIImage? = nil
    // 撮影画面（sheet）の開閉状態を管理
    @State var isShowSheet = false
    // フォトライブラリーで選択した写真を管理
    @State var photoPickerSelectedImage: PhotosPickerItem? = nil
    var body: some View {
        VStack {
            // スペースを追加
            Spacer()
            // 「カメラを起動する」ボタン
            Button {
                // ボタンをタップした時のアクション
                // カメラが利用可能かチェック
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    print("カメラは利用できます")
                    // 撮影写真を初期化する
                    captureImage = nil
                    // カメラが使えるなら、isShowSheetをtrue
                    isShowSheet.toggle()
                } else {
                    print("カメラは利用できません")
                }
            } label: {
                // テキスト表示
                Text("カメラを起動する")
                // 横幅いっぱい
                    .frame(maxWidth: .infinity)
                // 高さ50ポイントを指定
                    .frame(height: 50)
                // 文字列をセンタリング指定
                    .multilineTextAlignment(.center)
                // 背景を青色に指定
                    .background(Color.blue)
                // 文字色を白色に指定
                    .foregroundColor(Color.white)
            } // 「カメラを起動する」ボタンここまで
            // 上下左右に余白を追加
            .padding()
            // sheetを表示
            // isPresentedで指定した状態変数がtrueのとき実行
            .sheet(isPresented: $isShowSheet) {
                if let captureImage {
                    // 撮影した写真がある→EffectViewを表示する
                    EffectView(isShowSheet: $isShowSheet, captureImage: captureImage)
                } else {
                    // UIImagePckerController（写真撮影）を表示
                    ImagePickerView(isShowSheet: $isShowSheet, captureImage: $captureImage)
                }
                
            } //「カメラを起動する」ボタンのsheetここまで
            // フォトライブラリーから選択する
            PhotosPicker(selection: $photoPickerSelectedImage, matching: .images, preferredItemEncoding: .automatic, photoLibrary: .shared()) {
                // テキストを表示
                Text("フォトライブラリーから選択する")
                // 横幅いっぱい
                    .frame(maxWidth: .infinity)
                // 高さ50ポイント指定
                    .frame(height: 50)
                // 背景を青色に指定
                    .background(Color.blue)
                // 文字色を白色に指定
                    .foregroundColor(Color.white)
                // 上下左右に余白を追加
                    .padding()
            } // PhotosPicker ここまで
            // 選択した写真情報をもとに写真を取り出す
            .onChange(of: photoPickerSelectedImage) { photosPickerItem in
                // 選択した写真がある時
                if let photosPickerItem {
                    // Date型で写真を取り出す
                    photosPickerItem.loadTransferable(type: Data.self) { result in
                        switch result {
                        case .success(let data):
                            // 写真がある時
                            if let data {
                                // 撮影写真を初期化する
                                captureImage = nil
                                // 写真をcaptureImageに保存
                                captureImage = UIImage(data: data)
                            }
                        case .failure:
                            return
                        }
                    }
                }
            } //onChenge ここまで
        } // VStack ここまで
        // 撮影した写真を保存する状態変数が変化したら実行する
        .onChange(of: captureImage) { image in
            if let _ = image {
                // 撮影した写真がある→EffectViewを表示する
                isShowSheet.toggle()
            }
        } // .onChange ここまで
    } // body ここまで
} // ContentView ここまで

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

