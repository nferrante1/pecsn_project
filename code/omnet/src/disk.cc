//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

#include "disk.h"
#include "transaction_m.h"

namespace pecsn_project {

Define_Module(Disk);


Disk::~Disk(){
    if(beep_ != nullptr)
        cancelAndDelete(beep_);

    if(!queue->isEmpty()){
        queue->clear();
    }
    delete queue;
}

void Disk::initialize()
{
   workTimeSignal = registerSignal("working");
   if(!this->queue->isEmpty()) this->queue->clear();
   this->working = false;
}

void Disk::handleMessage(cMessage *msg)
{

    if(msg->isSelfMessage())
        handleSelfMessage(msg);
    else
        handleProcessorMessage(msg);

}

void Disk::handleProcessorMessage(cMessage* msg)
{

    EV<<"[handleProcessorMessage]: "<< msg->getFullName()<<"working: "<<this->working<<endl;
    if(this->working){
        this->queue->insert(msg);
    }

    else{

        beep_ = msg;

        workTime = exponential(par("serviceTimeMean").doubleValue());
        emit(workTimeSignal, workTime);
        scheduleAt(simTime() + workTime, beep_);

        this->working = true;
    }

}

void Disk::handleSelfMessage(cMessage *msg){
    send(msg, "out");
    beep_ = nullptr;//Send message to processor
    try {
        if (!queue->isEmpty()) {

            beep_= check_and_cast<cMessage *>(queue->pop());
            workTime = exponential(par("serviceTimeMean").doubleValue());
            emit(workTimeSignal, workTime);
            scheduleAt(simTime() + workTime, beep_);
            working = true;

        } else {
            working = false;
        }
    } catch (cRuntimeError *error) {
        EV << error->getFormattedMessage() << endl;
    }

}

} //namespace
