
#include<iostream>
#include<cstdlib>
using namespace std;

__global__ void vectorAdd(int *a, int *b, int *result, int n) {
    int tid = blockIdx.x*blockDim.x + threadIdx.x;
    if(tid <= n) {
        result[tid] = a[tid] + b[tid];
    }
}

void print_array(int *a, int N) {
    for(int i=0; i<N; i++) {
        cout<<"  "<<a[i];
    }
    cout<<endl;
}

void init_array(int *a, int N) {
    for(int i=0; i<N; i++) {
        a[i] = rand()%10 + 1;
    }
}

int main() {
    int *a, *b, *c;
    int *a_dev, *b_dev, *c_dev;
    int n = 8;           //24
    
    a = (int*)malloc(n * sizeof(n));
    b = (int*)malloc(n * sizeof(n));
    c = (int*)malloc(n * sizeof(n));

    int size = n * sizeof(int);
    
    cudaMalloc(&a_dev, size);
    cudaMalloc(&b_dev, size);
    cudaMalloc(&c_dev, size);
    
    init_array(a, n);
    init_array(b, n);
    
    print_array(a, n);
    print_array(b, n);
        
    //cudaEvent_t start, end;
    //cudaEventCreate(&start);
    //cudaEventCreate(&end);
    
    cudaMemcpy(a_dev, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(b_dev, b, size, cudaMemcpyHostToDevice);
    
    //int threads = 1024;
    //int blocks = (n+threads-1)/threads;
    
    //cudaEventRecord(start);
    
    //vectorAdd<<<blocks,threads>>>(a_dev, b_dev, c_dev, n);
    vectorAdd<<<1,1024>>>(a_dev, b_dev, c_dev, n);
    
    //cudaEventRecord(end);
    
    //cudaDeviceSynchronize();
       
    //float time = 0.0;
    //cudaEventElapsedTime(&time, start, end);
    
    cudaMemcpy(c, c_dev, size, cudaMemcpyDeviceToHost);
    
    cout<<"Results : "<<endl;
    print_array(c, n);
 
    //cout<<"Time elapsed : "<<time<<endl;
        
    cudaFree(a_dev);
    cudaFree(b_dev);
    cudaFree(c_dev);
        
    return 0;
}
