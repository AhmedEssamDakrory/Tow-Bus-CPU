#include <bits/stdc++.h>
using namespace std;
typedef pair<int, int>ii;
typedef long long ll;
#define sz(s) int((s).size())
#define mkp make_pair
#define debug(x) cout<<(#x)<<": \""<<x<<"\""<<endl;
#define sc(x) scanf("%d", &(x))
#define all(x) (x).begin(), (x).end()
#define F first
#define S second
const int N = (int) 2e5+1;
const int inf = (int) 1e9;
#include"assembler.h"

int main()
{
	Assembler a("file.txt");
	a.encode();
	a.Debug_print_codes();

}
