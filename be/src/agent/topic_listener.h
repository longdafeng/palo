// Copyright (c) 2017, Baidu.com, Inc. All Rights Reserved

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

#ifndef BDG_PALO_BE_SRC_AGENT_TOPIC_LISTENER_H
#define BDG_PALO_BE_SRC_AGENT_TOPIC_LISTENER_H

#include "gen_cpp/AgentService_types.h"

namespace palo {
  
class TopicListener {

public:
    
    virtual ~TopicListener(){}
    // Deal with a single update
    //
    // Input parameters:
    //   protocol version: the version for the protocol, listeners should deal with the msg according to the protocol
    //   topic_update: single update
    virtual void handle_update(const TAgentServiceVersion::type& protocol_version, 
                               const TTopicUpdate& topic_update) = 0;
};
}
#endif
