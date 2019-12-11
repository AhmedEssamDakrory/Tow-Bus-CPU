#pragma once
#include<bits/stdc++.h>
using namespace std;

struct Operand{
	bool Dir , noOperand ;
	int reg_num , mode;
	Operand(){
		Dir = false , noOperand = true;
		reg_num = 0;
		mode = 0;
	}
};


enum operand_type{
	NO_OPERAND,
	OPERAND_1,
	OPERAND_2,
	BR_OPERAND
};

enum Address_Mode{
	REG,
	AUTOINC,
	AUTODEC,
	INDEXED
};

class Assembler{

	const vector<string> operand_2{ "mov" , "add" , "adc" , "sub" , "suc" , "and" , "or" , "xnor" , "cmp" , "jsr" };
	const vector<string> operand_1{ "inc" , "dec" , "clr" , "inv" , "lsr" , "ror" , "rrc" , "asr" , "lsl" , "rol" ,"rlc" };
	const vector<string> operand_br{ "br" , "beq" , "bne" , "blo" , "rls" , "bhi" , "bhs" };
	const vector<string> operand_no{ "rts" , "interrupt" , "iret" , "hlt" , "nop"};
	// this vector contains instructions read from file
	vector<pair<string , pair<Operand , Operand>>> instr;
	//this vector contains op codes
	vector<bitset<16>> codes;
	// utility functions  //***********************************************************************************//

	int operationType(string s){
		int type = -1;
		for(auto x : operand_2 ){
			if(type != -1) break;
			if(x == s) { type = OPERAND_2; break;}
		}
		for(auto x : operand_1 ){
			if(type != -1) break;
			if(x == s) {type = OPERAND_1; break;}
		}
		for(auto x : operand_br ){
			if(type != -1) break;
			if(x == s) { type = BR_OPERAND; break; }
		}
		for(auto x : operand_no ){
			if(type != -1) break;
			if(x == s) { type = NO_OPERAND; break;}
		}
		return type;
	}

	bitset<16> toBinary(int n){
		bitset<16> b;
		int i = 0;
		while(n > 0){
			if(n%2) b[i] = 1;
			n/=2;
			i++;
		}
		return b;
	}

	string fetchOperation(string s , int& i){
		// fetching operation
		while(s[i] == ' ') ++i;
		string op="";
		while(s[i] != ' ') op += tolower(s[i++]);
		return op;
	}

	Operand parseString(string s){
		int i = 0;
		// checking if direct or in indirect
		Operand operand;
		while(s[i] == ' ') ++i;
		if(s[i] != '@') operand.Dir = true;
		if( !operand.Dir  ) i++;
		//checking if autoDecrement or indexed
		while(s[i] == ' ') ++i;
		string oper = "";
		if(s[i] == '-') {
			operand.mode = AUTODEC , i++;
			while(s[i] == ' ' || s[i] == '(') i++;
			while(s[i] != ' ' && s[i] != ')') oper += tolower(s[i++]);
		}
		else{
			string indx = "";
			while(s[i] != ' ' && s[i] != '(' && i< (int) s.size()) indx += tolower(s[i++]);
			while(s[i] == ' ' && i <(int) s.size()) ++i;
			if(s[i] == '(' && indx != "") operand.mode = INDEXED;
			if(i == (int)s.size()) oper = indx;
			else{
				i++;
				while(s[i] ==' ') ++i;
				while(s[i] != ' ' && s[i] != ')') oper += tolower(s[i++]);
				while((s[i] ==' ' || s[i] ==')') && i < (int) s.size() ) ++i;
				if(i < (int) s.size() && s[i] == '+') operand.mode = AUTOINC;
			}
		}
		operand.reg_num = oper[(int)oper.size()-1]-'0';
		return operand;
	}
	bitset<4> encode_2_operand(string s){
		bitset<4> b;
		int l = 3 , r = 0;
		for(auto x : operand_2){
			if(x == s){
				b[r] = 1;
				break;
			}
			++r;
			if(r == l) b[r] = 1 , r = 0 , l--;
		}
		return b;
	}

	bitset<4> encode_1_operand(string s){
		bitset<4> b;
		if(s == "rlc") return b;
		int l = 3 , r = 0;
		for(auto x : operand_1){
			if(x == s){
				b[r] = 1;
				break;
			}
			++r;
			if(r == l) b[r] = 1 , r = 0 , l--;
		}
		return b;
	}



public:

	Assembler(string file_name){
		ifstream cin; cin.open(file_name);
		string s;
		while(getline(cin , s)){
			int i =0;
			string op = fetchOperation(s,i);
			string s1 = "";
			while(s[i] != ',' && i < (int)s.size()) s1 += s[i++];
			Operand operand1 = parseString(s1);
			operand1.noOperand = false;
			Operand operand2;
			if(i<(int) s.size()){
				i++;
				string s2 = "";
				while(i<(int) s.size()) s2 += s[i++];
				operand2 = parseString(s2);
				operand2.noOperand = false;
			}
			instr.push_back({op , {operand1 , operand2}});
		}

	}

	void encode(){
		for(auto instruction : instr){
			bitset<16> code;
			string op = instruction.first;
			int op_type = operationType(op);
			if(op_type == OPERAND_2){
				bitset<4> b = encode_2_operand(op);
				int j=0;
				for(int i = 12 ; i < 16 ; i++) code[i] = b[j++];
				if(!instruction.second.first.Dir) code[11] = 1;
				if(!instruction.second.second.Dir) code[5] = 1;
				int mode_src  =  instruction.second.first.mode;
				int mode_dest = instruction.second.second.mode;
				if(mode_src == AUTOINC) code[9] = 1;
				else if(mode_src == AUTODEC) code[10] = 1;
				else if(mode_src == INDEXED) code[9] = 1 , code[10] = 1;
				if(mode_dest == AUTOINC) code[3] = 1;
				else if(mode_dest == AUTODEC) code[4] = 1;
				else if(mode_dest == INDEXED) code[3] = 1 , code[4] = 1;
				bitset<16> src_num = toBinary(instruction.second.first.reg_num);
				bitset<16> dest_num = toBinary(instruction.second.second.reg_num);
				j = 0;
				for(int i = 0 ; i <= 2 ; i++) code[i] = dest_num[j++];
				j = 0;
				for(int i = 6 ; i <= 8 ; i++) code[i] = src_num[j++];
			}
			else if(op_type == OPERAND_1){
				bitset<4> b = encode_1_operand(op);
				code[10] = 1;
				int j = 0;
				for(int i = 6 ; i<=9; ++i) code[i] = b[j++];
				if(!instruction.second.first.Dir) code[5] = 1;
				int mode_src  =  instruction.second.first.mode;
				if(mode_src == AUTOINC) code[3] = 1;
				else if(mode_src == AUTODEC) code[4] = 1;
				else if(mode_src == INDEXED) code[3] = 1 , code[4] = 1;
				bitset<16> src_num = toBinary(instruction.second.first.reg_num);
				j = 0;
				for(int i = 0 ; i <= 2 ; i++) code[i] = src_num[j++];
			}
			codes.push_back(code);
		}
	}

	void Debug_print_instr(){
		for(auto x : instr){
			cout<<x.first<<" ";
			printf("%d %d %d -- %d %d %d\n"  , x.second.first.Dir , x.second.first.mode , x.second.first.reg_num ,x.second.second.Dir , x.second.second.mode , x.second.second.reg_num );
		}
	}

	void Debug_print_codes(){
		for(auto x : codes) cout<<x.to_string()<<endl;
	}

};
