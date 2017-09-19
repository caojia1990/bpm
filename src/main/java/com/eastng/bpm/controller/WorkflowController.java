package com.eastng.bpm.controller;

import org.activiti.engine.FormService;
import org.activiti.engine.form.StartFormData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class WorkflowController {

    @Autowired
    private FormService formService;

    @RequestMapping(value = "workflow/{processDefinitionId}/start")
    public ModelAndView startProcess(@PathVariable String processDefinitionId) {

        String viewName = "workflow/start";
        ModelAndView mav = new ModelAndView(viewName);
        StartFormData startFormData = formService.getStartFormData(processDefinitionId);
        mav.addObject("startFormData", startFormData);
        mav.addObject("processDefinitionId", processDefinitionId);
        return mav;
    }

    @RequestMapping(value = "workflow/index")
    public String toWorkflowIndex() {
        return "workflow/index";
    }

    @RequestMapping(value = "workflow/model")
    public String toWorkflowModel() {
        return "workflow/model";
    }
    
    @RequestMapping(value = "workflow/process")
    public String toWorkflowProcess() {
        return "workflow/process";
    }
    
    @RequestMapping(value = "workflow/runtime")
    public String toWorkflowProcessInstance() {
        return "workflow/runtime";
    }
}
