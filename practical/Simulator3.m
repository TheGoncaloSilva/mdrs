function [PLdata, PLvoip , APDdata, APDvoip , MPDdata, MPDvoip , TT] = Simulator3(lambda,C,f,P,n)
% INPUT PARAMETERS:
%  lambda - packet rate (packets/sec)
%  C      - link bandwidth (Mbps)
%  f      - queue size (Bytes)z
%  P      - number of packets (stopping criterium)
%  n      - VOIP packet flows
% OUTPUT PARAMETERS:
%  PLdata   - data packet loss (%)
%  PLvoip   - voip packet loss ()
%  APDdata  - average packet delay (milliseconds)
%  APDvoip  - average voip packet delay (milliseconds)
%  MPDdata  - maximum packet delay (milliseconds)
%  MPDvoip  - maximum voip packet delay (milliseconds)
%  TT   - transmitted throughput (Mbps)

%Events:
ARRIVAL= 0;       % Arrival of a packet            
DEPARTURE= 1;     % Departure of a packet

%packet_types
DATA=0;
VOIP=1;

%State variables:
STATE= 0;          % 0 - connection free; 1 - connection bysy
QUEUEOCCUPATION= 0; % Occupation of the queue (in Bytes)
QUEUE= [];          % Size and arriving time instant of each packet in the queue

%Statistical Counters:
TOTALPACKETSdata= 0;       % No. of data packets arrived to the system data
TOTALPACKETSvoip= 0;       % No. of voip packets arrived to the system data voip
LOSTPACKETSdata= 0;        % No. of data packets dropped due to buffer overflow
LOSTPACKETSvoip= 0;        % No. of voip packets dropped due to buffer overflow
TRANSMITTEDPACKETSdata= 0; % No. of transmitted data packets
TRANSMITTEDPACKETSvoip= 0; % No. of transmitted voip packets
TRANSMITTEDBYTES= 0;   % Sum of the Bytes of transmitted packets
DELAYSdata= 0;             % Sum of the DELAYS of transmitted data packets
DELAYSvoip= 0;             % Sum of the DELAYSdata of transmitted voip packets
MAXDELAYdata= 0;           % Maximum delay among all transmitted data packets
MAXDELAYvoip= 0;           % Maximum delay among all transmitted voip packets

% Initializing the simulation clock:
Clock= 0;

% Initializing the List of Events with the first ARRIVAL:
tmp= Clock + exprnd(1/lambda);
% flag 0 -> data packets, 1 -> voip packets
Event_List= [ARRIVAL, tmp, GeneratePacketSize(), tmp, DATA];
% Initializing the voip packets:
for i=1:n
    time = Clock + unifrnd(0, 0.020);
    Event_List= [Event_List; ARRIVAL, time, randi([110 130]), time, VOIP];
end

%Simulation loop:
while (TRANSMITTEDPACKETSdata+TRANSMITTEDPACKETSvoip)<P               % Stopping criterium
    Event_List= sortrows(Event_List,2);  % Order EventList by time
    Event= Event_List(1,1);              % Get first event and 
    Clock= Event_List(1,2);              %   and
    Packet_Size= Event_List(1,3);        %   associated
    Arrival_Instant= Event_List(1,4);    %   parameters.
    packetType= Event_List(1,5);
    Event_List(1,:)= [];                 % Eliminate first event
    if Event == ARRIVAL         % If first event is an ARRIVAL
        if packetType == DATA                % data packet
            TOTALPACKETSdata= TOTALPACKETSdata+1;
            tmp= Clock + exprnd(1/lambda);
            Event_List = [Event_List; ARRIVAL, tmp, GeneratePacketSize(), tmp, DATA];
        else                            % voip packet
            TOTALPACKETSvoip= TOTALPACKETSvoip+1;
            tmp = Clock + unifrnd(0.016, 0.024);
            Event_List = [Event_List; ARRIVAL, tmp, randi([110 130]), tmp, VOIP];
        end
        if STATE==0
            STATE= 1;
            Event_List = [Event_List; DEPARTURE, Clock + 8*Packet_Size/(C*10^6), Packet_Size, Clock, packetType];
        else
            if QUEUEOCCUPATION + Packet_Size <= f
                QUEUE= [QUEUE;Packet_Size , Clock, packetType];
                QUEUEOCCUPATION= QUEUEOCCUPATION + Packet_Size;
            else
                if packetType == DATA                % data packet
                    LOSTPACKETSdata= LOSTPACKETSdata + 1;
                else                            % voip packet
                    LOSTPACKETSvoip= LOSTPACKETSvoip + 1;
                end
            end
        end
    else                        % If first event is a DEPARTURE
        TRANSMITTEDBYTES= TRANSMITTEDBYTES + Packet_Size;
        if packetType == DATA                % data packet
            DELAYSdata= DELAYSdata + (Clock - Arrival_Instant);
            if Clock - Arrival_Instant > MAXDELAYdata
                MAXDELAYdata= Clock - Arrival_Instant;
            end
            TRANSMITTEDPACKETSdata= TRANSMITTEDPACKETSdata + 1;
        else                            % voip packet
            DELAYSvoip= DELAYSvoip + (Clock - Arrival_Instant);
            if Clock - Arrival_Instant > MAXDELAYvoip
                MAXDELAYvoip= Clock - Arrival_Instant;
            end
            TRANSMITTEDPACKETSvoip= TRANSMITTEDPACKETSvoip + 1;
        end
        
        if QUEUEOCCUPATION > 0
            Event_List = [Event_List; DEPARTURE, Clock + 8*QUEUE(1,1)/(C*10^6), QUEUE(1,1), QUEUE(1,2), QUEUE(1,3)];
            QUEUEOCCUPATION= QUEUEOCCUPATION - QUEUE(1,1);
            QUEUE(1,:)= [];
        else
            STATE= 0;
        end
    end
end

%Performance parameters determination:
PLdata= 100*LOSTPACKETSdata/TOTALPACKETSdata;      % in %
PLvoip= 100*LOSTPACKETSvoip/TOTALPACKETSvoip;      % in %
APDdata= 1000*DELAYSdata/TRANSMITTEDPACKETSdata;   % in milliseconds
APDvoip= 1000*DELAYSvoip/TRANSMITTEDPACKETSvoip;   % in milliseconds
MPDdata= 1000*MAXDELAYdata;                    % in milliseconds
MPDvoip= 1000*MAXDELAYvoip;                    % in milliseconds
TT= 10^(-6)*TRANSMITTEDBYTES*8/Clock;  % in Mbps

end

function out= GeneratePacketSize()
    aux= rand();
    aux2= [65:109 111:1517];
    if aux <= 0.19
        out= 64;
    elseif aux <= 0.19 + 0.23
        out= 110;
    elseif aux <= 0.19 + 0.23 + 0.17
        out= 1518;
    else
        out = aux2(randi(length(aux2)));
    end
end