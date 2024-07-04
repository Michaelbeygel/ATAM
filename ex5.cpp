#include <iostream>

using namespace std;

int checkAritmeticOfAritmetics(int arr[5]) {
    int first_diff = arr[1] - arr[0];
    int diffs_diff = arr[2] - arr[1] - first_diff;
    for (int i = 2; i < 5; i++) {
        if (arr[i] - arr[i - 1] - first_diff != diffs_diff) {
            return 0;
        }
        first_diff = arr[i] - arr[i - 1];
    }
    return 1;
}

int checkGeomerticOfGeometrics(int arr[5]) {
    int first_ratio = arr[1] / arr[0];
    int ratios_ratio = arr[2] / arr[1] / first_ratio;
    for (int i = 2; i < 5; i++) {
        if (arr[i] / arr[i - 1] / first_ratio != ratios_ratio) {
            return 0;
        }
        first_ratio = arr[i] / arr[i - 1];
    }
    return 1;
}

int checkAritmeticOfGeometrics(int arr[5]) {
    int first_ratio = arr[1] / arr[0];
    int ratios_diff = arr[2] / arr[1] - first_ratio;
    for (int i = 2; i < 5; i++) {
        if (arr[i] / arr[i - 1] - first_ratio != ratios_diff) {
            return 0;
        }
        first_ratio = arr[i] / arr[i - 1];
    }
    return 1;
}

int checkGeometricOfAritmetics(int arr[5]) {
    int first_diff = arr[1] - arr[0];
    int diffs_ratio = (arr[2] - arr[1]) / first_diff;
    for (int i = 2; i < 5; i++) {
        cout << (arr[i] - arr[i - 1]) / first_diff << endl;
        if ((arr[i] - arr[i - 1]) / first_diff != diffs_ratio) {
            return 0;
        }
        first_diff = arr[i] - arr[i - 1];
    }
    return 1;
}

int main() {
    // int arr[5] = {1, 2, 3, 4, 5}; // Test case 1
    // cout << "Test case 1" << endl;
    // cout << checkAritmeticOfAritmetics(arr) << endl;
    // cout << checkGeomerticOfGeometrics(arr) << endl;
    // cout << checkAritmeticOfGeometrics(arr) << endl;
    // cout << checkGeometricOfAritmetics(arr) << endl;

    // int arr2[] = {2, 4, 8, 16, 32}; // Test case 2
    // cout << "Test case 2" << endl;
    // cout << checkAritmeticOfAritmetics(arr2) << endl;
    // cout << checkGeomerticOfGeometrics(arr2) << endl;
    // cout << checkAritmeticOfGeometrics(arr2) << endl;
    // cout << checkGeometricOfAritmetics(arr2) << endl;

    int arr3[] = {1, 3, 6, 10, 15}; // Test case 3
    cout << "Test case 3" << endl;
    // cout << checkAritmeticOfAritmetics(arr3) << endl;
    // cout << checkGeomerticOfGeometrics(arr3) << endl;
    // cout << checkAritmeticOfGeometrics(arr3) << endl;
    cout << checkGeometricOfAritmetics(arr3) << endl;

    return 0;
}