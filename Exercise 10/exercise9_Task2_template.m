clear %clear all variables from the workspace
close all %close all figures

%m: number of projects
m=40; 
%muu: expected profits of the projects
muu=[571 801 75	178	134	155	236	306	708	779	734	519	345	492	451	26	930	431	155	229	299	863	754	688	425	51	445	652	338	893	499	601	89	341	101	161	539	134	722	835
]';
%std: standard deviations of the profits of the projects 
std=[17	41	57	76	11	76	81	42	39	42	61	98	82	5	1	42	42	2	45	44	14	78	7	71	96	20	57	39	85	97	22	23	46	36	91	19	2	61	5	45
]';
%c: projects' costs
c=[4 3	9	5	3	2	7	7	10	10	4	7	2	1	2	10	2	1	1	9	0	10	4	4	7	4	5	2	2	1	1	7	7	2	7	4	10	9	10	3
];
%b: R&D budget
b=80;
%r: project presentation info with regard to the research divisions 
%r(i,j)=1 if division i presents project j, otherwise r(i,j)=0
r=[1	1	1	1	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	1	1	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0
0	0	0	0	0	0	1	1	1	1	1	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	1	1	1	1	1	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	1	1	1	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	1	1	1	1	1
];

%f1 and f2: objective functions (1. part missing from template)
f1=XXXX
f2=XXXX
%A: constraint matrix
A(1,:)=c;
A(2,:)=-c.*r(1,:);
A(3,:)=-c.*r(2,:);
A(4,:)=-c.*r(3,:);
%B: constraint vector
B=zeros(4,1);
B(1)=b;
B(2)=-b*0.2;
B(3)=-b*0.2;
B(4)=-b*0.2;
%vlb: lower bounds of decision variables 
vlb=zeros(m,1);
%vlb: upper bounds of decision variables 
vub=ones(m,1);
%xint: indices of integer valued variables
xint=1:m;
%e: definition of constraint relation types
e=ones(4,1)*-1;

%Compute utopian vector
[x, utopian_muu, exitflag] = intlinprog(-f1, xint, A,B, [], [], vlb, vub);
[x, utopian_var, exitflag] = intlinprog(f2, xint, A,B, [], [], vlb, vub);
utopian_muu=-1.01*utopian_muu;
utopian_var=0.99*utopian_var;

%Initialize plots
figure
subplot(2,2,1)
plot(utopian_var,utopian_muu,'rx');
hold on
grid on
xlabel('Var')
ylabel('\mu')
axis([0 8 0 1.7]*10^4)

subplot(2,2,2)
axis([0 1 0 1])
xlabel('\lambda_1')
ylabel('\lambda_2')
grid on
hold on

%Set of PO-solutions initialized as an empty set
X=[];

%main loop
for k=1:100
    %generate lambda:
    lambda=rand(2,1);
    lambda=lambda/sum(lambda);
    subplot(2,2,2)
    plot(lambda(1),lambda(2),'.')
    axis([0 1 0 1])
    hold on
    
    %Weighted sum ----------------------------------------------------------
    %(2. part missing from template)
    [x, WS, exitflag] = intlinprog(DEFINE_OBJECTIVE_FUNCTION_AND_CONSTRAINTS_HERE);
    
    %Update X
    dublicate=0;
    if (size(X)~=[0,0])
        for d=1:size(X,1)
            if max(abs(X(d,:)-x')) < 10^(-3)
                dublicate=1;
                break;
            end
        end
    end
    if (dublicate==0)
        X=[X ; x'];
        subplot(2,2,1);
        plot(x'*f2,x'*f1,'k.') %plot a new solution in black
    end
    
    %Weighted max-norm  ----------------------------------------------------------
    %(3. part missing from template)
    [x2, WS, exitflag] = intlinprog(DEFINE_OBJECTIVE_FUNCTION_AND_CONSTRAINTS_HERE);
    
    x=x2(1:m); %discard the optimal value of delta
   
    %Update X
    dublicate=0;
    if (size(X)~=[0,0])
        for d=1:size(X,1)
            if max(abs(X(d,:)-x')) < 10^(-3)
                dublicate=1;
                break;
            end
        end
    end
    if (dublicate==0)
        X=[X ; x'];
        subplot(2,2,1);
        plot(x'*f2,x'*f1,'r.') %plot a new solution in red
    end
    
    %Decision variable values 
    subplot(2,2,3);
    bar(sum(X)/size(X,1))
    axis([0.5 m+0.5 0 1])
    xlabel('j')
    ylabel('Share of PO-solutions with x_j=1')
    
    %(M)ILPs solved versus PO-solutions found
    subplot(2,2,4)
    plot(2*k,size(X,1),'.')
    xlabel('MILPs and ILPs solved')
    ylabel('Number of PO-solutions found')
    hold on
    drawnow
end