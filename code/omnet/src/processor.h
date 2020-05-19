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

#ifndef __PECSN_PROJECT_PROCESSOR_H_
#define __PECSN_PROJECT_PROCESSOR_H_

#include <omnetpp.h>
#include "action.h"

using namespace omnetpp;

namespace pecsn_project {

class Processor: public cSimpleModule {
private:
    cMessage *beep_ = nullptr;
    cQueue *queue = new cQueue();
    bool working = false;
    long completedTransactions = 0;
    simsignal_t completeSignal;
    simtime_t workTime;
    simsignal_t workTimeSignal;

protected:
    virtual void initialize();
    virtual void handleMessage(cMessage *msg);
    virtual void handleSelfMessage(cMessage *msg);
    virtual void handleRemoteMessage(cMessage *msg);
    virtual Action evaluateAction();
public:
    virtual ~Processor();
};

} //namespace

#endif
